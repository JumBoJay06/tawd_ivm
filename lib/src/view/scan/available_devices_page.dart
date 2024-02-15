import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/bloc/device_text_field/device_text_field_bloc.dart';
import 'package:tawd_ivm/src/bloc/ivm/scan/scan_bloc.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/util/dialog_loading.dart';
import 'package:tawd_ivm/src/util/dialog_widget_util.dart';

import '../../../generated/l10n.dart';
import '../../../route.dart';
import '../../bloc/ivm/manager/ivm_connection_bloc.dart';
import '../../theme/style.dart';

class AvailableDevicesPage extends StatefulWidget {
  const AvailableDevicesPage({super.key});

  @override
  State<AvailableDevicesPage> createState() => _AvailableDevicesPageState();
}

class _AvailableDevicesPageState extends State<AvailableDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return _availableDevices();
  }
}

class _availableDevices extends StatelessWidget {
  Logger get _logger => Logger("AvailableDevices");

  @override
  Widget build(BuildContext context) {
    context.read<ScanBloc>().add(ScanStart(8));
    return Stack(
      children: [
        _createTitleWidget(context),
        BlocBuilder<ScanBloc, ScanState>(
            builder: (context, state) {
              if (state is ScanFailure) {
                DialogLoading.dismissLoading('scan');
                return _createEmptyDeviceWidget(context);
              }
              if (state is ScanStarting) {
                DialogLoading.showLoading('scan', content: S.of(context).available_device_searching);
              }
              if (state is ScanSuccess) {
                DialogLoading.dismissLoading('scan');
                return _createDeviceWidget(state.scanResults);
              }
              if (state is FilterResults) {
                return _createDeviceWidget(state.scanResults);
              }
              return _createEmptyDeviceWidget(context);
            }),
        Positioned(
            bottom: 48.h,
            left: 16.w,
            right: 16.w,
            child: _createScanAgainWidget(context))
      ],
    );
  }

  Widget _createTitleWidget(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: BlocBuilder<DeviceTextFieldBloc, DeviceTextFieldState>(
          builder: (context, state) {
            if (state is DeviceTextFieldInitial) {
              return _createNormalTitleWidget(context);
            } else {
              return _createSearchTitleWidget(context);
            }
          },
        ));
  }

  Widget _createNormalTitleWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 375.w,
          height: 812.h,
          color: ColorTheme.background,
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/header_bg_1.png',
              width: 375.w,
              height: 100.h,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 58.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, kRouteSelectLanguage, (route) => false);
              },
              child: Image.asset(
                'assets/light_6.png',
                width: 24.w,
                height: 24.h,
              ),
            )),
        Positioned(
            top: 64.h,
            left: 0,
            right: 0,
            child: Text(S.of(context).available_device,
                style: const TextStyle(
                    color: ColorTheme.fontColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center)),
        Positioned(
            top: 58.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                context.read<DeviceTextFieldBloc>().add(StartFilter());
              },
              child: Image.asset(
                'assets/light_9.png',
                width: 24.w,
                height: 24.h,
              ),
            ))
      ],
    );
  }

  Widget _createSearchTitleWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 375.w,
          height: 812.h,
          color: ColorTheme.background,
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/header_bg_1.png',
              width: 375.w,
              height: 100.h,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 58.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, kRouteSelectLanguage, (route) => false);
              },
              child: Image.asset(
                'assets/light_6.png',
                width: 24.w,
                height: 24.h,
              ),
            )),
        Positioned(
            top: 48.h,
            left: 44.w,
            right: 61.w,
            child: // 矩形
            Container(
                width: 270.w,
                height: 44.h,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(22)
                    ),
                    color: ColorTheme.white
                ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  onChanged: (filter) {
                    context.read<ScanBloc>().add(Filter(filter));
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter device number for quick search',
                    hintStyle: TextStyle(
                        color:  ColorTheme.primaryAlpha_20,
                        fontWeight: FontWeight.w400,
                        fontFamily: "SFProDisplay",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    )
                  ),
                ),
              ),
            )),
        Positioned(
            top: 62.h,
            right: 16.w,
            child:GestureDetector(
              onTap: () {
                context.read<DeviceTextFieldBloc>().add(StopFilter());
                context.read<ScanBloc>().add(Filter(''));
              },
              child: Text(
                  S.of(context).common_cancel,
                  style: const TextStyle(
                      color:  ColorTheme.fontColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProDisplay",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  ),
                  textAlign: TextAlign.right
              ),
            ))
      ],
    );
  }

  Widget _createEmptyDeviceWidget(BuildContext context) {
    return Positioned(
        top: 0,
        child: SizedBox(
          width: 375.w,
          height: 608.h,
          child: Stack(
            children: [
              Positioned(
                  top: 120.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/background_round.png',
                    width: 240.w,
                    height: 185.h,
                  )),
              Positioned(
                  top: 160.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/icon_device_list.png',
                    width: 145.w,
                    height: 145.h,
                  )),
              Positioned(
                  top: 320.h,
                  left: 0,
                  right: 0,
                  child: const Text('No available devices',
                      style: TextStyle(
                          color: ColorTheme.primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 24.0),
                      textAlign: TextAlign.center))
            ],
          ),
        ));
  }

  Widget _createDeviceWidget(List<ScanResult> scanResults) {
    return Positioned(
        top: 100.h,
        bottom: 104.h,
        left: 16.w,
        right: 16.w,
        child: ListView.builder(
            itemCount: scanResults.length,
            itemBuilder: (BuildContext context, int index) {
              return _createListItem(context, scanResults[index]);
            }));
  }

  Widget _createScanAgainWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ScanBloc>().add(ScanStart(8));
      },
      child: Container(
        width: 343.w,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.h)),
          boxShadow: const [
            BoxShadow(
                color: ColorTheme.primary,
                offset: Offset(0, 10),
                blurRadius: 25,
                spreadRadius: 0)
          ],
          gradient: const LinearGradient(
              begin: Alignment(0.6116728186607361, 0),
              end: Alignment(0.37270376086235046, 1.0995962619781494),
              colors: [ColorTheme.secondaryGradient, ColorTheme.secondary]),
        ),
        child: Center(
          child: Text(
            S.of(context).available_device_research,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorTheme.fontColor),
          ),
        ),
      ),
    );
  }

  Widget _createListItem(BuildContext context, ScanResult result) {
    return BlocListener<IvmConnectionBloc, IvmConnectionState>(
        listener: (context, state) async {
          if (state is IvmConnectionStateChange) {
            final connectResult = state.state;
            switch (connectResult) {
              case IvmConnectionStatus.disconnected:
                DialogLoading.dismissLoading('connecting');
                _showPairFail();
                break;
              case IvmConnectionStatus.connecting:
                DialogLoading.showLoading('connecting');
                break;
              case IvmConnectionStatus.connected:
                var pairingDataHistory = await IvmManager.getInstance().getPairingDataHistory();
                bool isHadId = false;
                if (pairingDataHistory != null && pairingDataHistory.isNotEmpty) {
                  var ivmId = pairingDataHistory.last.valveId;
                  isHadId = ivmId.isNotEmpty;
                }
                DialogLoading.dismissLoading('connecting');
                if (isHadId) {
                  _showPairedWithId(context, result.device.platformName);
                } else {
                  _showPairedWithoutId(context, result.device.platformName);
                }
                break;
            }
          }
        },
    child: InkWell(
      onTap: () async {
        context.read<IvmConnectionBloc>().add(IvmConnect(result.device));
      },
      child: SizedBox(
        width: 343.w,
        height: 57.h,
        child: Stack(
          children: [
            Positioned(
                top: 18.h,
                bottom: 18.h,
                left: 8.w,
                child:
                Text(
                    result.device.platformName,
                    style: const TextStyle(
                        color:  ColorTheme.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SFProDisplay",
                        fontStyle:  FontStyle.normal,
                        fontSize: 16.0
                    ),
                    textAlign: TextAlign.left
                )),
            Positioned(
                top: 56.h,
                left: 0,
                right: 0,
                child: Container(
                    width: 343.w,
                    height: 1.h,
                    decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10)))
          ],
        ),
      ),
    ),);

  }

  void _showPairedWithoutId(BuildContext myContext, String deviceName) {
    SmartDialog.show(builder: (context) {
      return DialogWidgetUtil.pairedWithoutIdDialog(myContext, deviceName, () {
        SmartDialog.dismiss(tag: 'pair_without_id');
        Navigator.pushNamed(context, kRouteReplaceBallValvePage).then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                myContext, kRouteActionMenu, (route) => false));
      }, () {
        SmartDialog.dismiss(tag: 'pair_without_id');
        Navigator.pushNamedAndRemoveUntil(myContext, kRouteActionMenu, (route) => false);
      });
    }, tag: 'pair_without_id');
  }

  void _showPairedWithId(BuildContext myContext, String deviceName) {
    SmartDialog.show(builder: (context) {
      return DialogWidgetUtil.pairedWithIdDialog(context, deviceName, () {
        SmartDialog.dismiss(tag: 'pair_with_id');
        Navigator.pushNamedAndRemoveUntil(context, kRouteActionMenu, (route) => false);
      });
    }, tag: 'pair_with_id');
  }

  void _showPairFail() {
    SmartDialog.show(builder: (context) {
      return DialogWidgetUtil.pairFailDialogForScan(context, () => {
        SmartDialog.dismiss(tag: 'pair_fail')
      });
    }, tag: 'pair_fail');
  }
}


