import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/route.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_connection_bloc.dart';
import 'package:tawd_ivm/src/bloc/paired_device/paired_device_bloc.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/util/dialog_loading.dart';
import 'package:tawd_ivm/src/util/mac_address_util.dart';

import '../../../generated/l10n.dart';
import '../../bloc/device_text_field/device_text_field_bloc.dart';
import '../../data/paired_device.dart';
import '../../theme/style.dart';
import '../../util/dialog_widget_util.dart';

class PairedPage extends StatefulWidget {
  const PairedPage({super.key});

  @override
  State<PairedPage> createState() => _PairedPageState();
}

class _PairedPageState extends State<PairedPage> {
  IvmConnectionBloc ivmConnectionBloc = IvmConnectionBloc();

  Logger get _logger => Logger("PairedPage");
  bool isDeviceClicked = false;

  @override
  void initState() {
    super.initState();
    context.read<PairedDeviceBloc>().add(GetPairedDevices());
    context.read<DeviceTextFieldBloc>().add(StopFilter());
  }

  @override
  void dispose() {
    ivmConnectionBloc.close();
    isDeviceClicked = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          context.read<DeviceTextFieldBloc>().add(StopFilter());
          Navigator.pushNamedAndRemoveUntil(
              context, kRouteScanStartPage, (route) => false);
        },
        child: Stack(
          children: [
            _createTitleWidget(context),
            BlocBuilder<PairedDeviceBloc, PairedDeviceState>(
                builder: (context, state) {
              if (state.deviceList.isEmpty) {
                _logger.info('show empty');
                return _createEmptyDeviceListWidget(context);
              } else {
                _logger.info('show list(${state.deviceList.length})');
                return _createDeviceListWidget(context, state.deviceList);
              }
            })
          ],
        ));
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
            child: Image.asset(
              'assets/light_6.png',
              width: 24.w,
              height: 24.h,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 46.h,
            left: 4.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                context.read<DeviceTextFieldBloc>().add(StopFilter());
                Navigator.pushNamedAndRemoveUntil(
                    context, kRouteScanStartPage, (route) => false);
              },
              child: Container(
                color: ColorTheme.secondaryAlpha_10,
                width: 48.w,
                height: 48.h,
              ),
            )),
        Positioned(
            bottom: 728.h,
            left: 56.w,
            right: 56.w,
            child: Text(S.of(context).ivm_service_paired_device,
                style: TextStyle(
                    color: ColorTheme.fontColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0.sp),
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
            child: Image.asset(
              'assets/light_6.png',
              fit: BoxFit.fill,
              width: 24.w,
              height: 24.h,
            )),
        Positioned(
            top: 46.h,
            left: 4.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                context.read<DeviceTextFieldBloc>().add(StopFilter());
                Navigator.pushNamedAndRemoveUntil(
                    context, kRouteScanStartPage, (route) => false);
              },
              child: SizedBox(
                width: 48.w,
                height: 48.h,
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
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  color: ColorTheme.white),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w),
                  child: TextField(
                    onChanged: (filter) {
                      context.read<PairedDeviceBloc>().add(Filter(filter));
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: S
                            .of(context)
                            .available_device_type_device_number_quickly_find_content,
                        hintStyle: TextStyle(
                            color: ColorTheme.primaryAlpha_20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0.sp)),
                  ),
                ),
              ),
            )),
        Positioned(
            top: 62.h,
            left: 318.w,
            child: GestureDetector(
              onTap: () {
                context.read<DeviceTextFieldBloc>().add(StopFilter());
              },
              child: Text(S.of(context).common_cancel,
                  style: TextStyle(
                      color: ColorTheme.fontColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.right),
            ))
      ],
    );
  }

  Widget _createEmptyDeviceListWidget(BuildContext context) {
    return Positioned(
        top: 100.h,
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
                  child: Text(
                      S.of(context).available_device_no_paired_device_content,
                      style: TextStyle(
                          color: ColorTheme.primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 24.0.sp),
                      textAlign: TextAlign.center)),
              Positioned(
                  top: 353.h,
                  left: 0,
                  right: 0,
                  child: Text(
                      S
                          .of(context)
                          .available_device_please_connect_first_content,
                      style: TextStyle(
                          color: ColorTheme.primaryAlpha_50,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0.sp),
                      textAlign: TextAlign.center))
            ],
          ),
        ));
  }

  Widget _createDeviceListWidget(
      BuildContext context, List<PairedDevice> deviceList) {
    _logger.info('_createDeviceListWidget');
    return Stack(
      children: [
        Positioned(
            top: 124.h,
            left: 16.w,
            child: Text(
                S.of(context).available_device_show_devices_paired_content,
                style: TextStyle(
                    color: ColorTheme.secondary,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0.sp),
                textAlign: TextAlign.left)),
        Positioned(
            top: 149.h,
            bottom: 0,
            left: 16.w,
            right: 16.w,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: deviceList.length,
                itemBuilder: (BuildContext context, int index) =>
                    _createListItem(context, deviceList[index])))
      ],
    );
  }

  Widget _createListItem(BuildContext context, PairedDevice device) {
    _logger.info('_createListItem');
    final deviceName = MacAddressUtil.getMacAddressText(device.name);
    return BlocListener<IvmConnectionBloc, IvmConnectionState>(
      bloc: ivmConnectionBloc,
      listener: (context, state) async {
        if (state is IvmConnectionStateChange) {
          final result = state.state;
          switch (result) {
            case IvmConnectionStatus.disconnected:
              DialogLoading.dismissLoading('connecting');
              _showPairFail();
              break;
            case IvmConnectionStatus.connecting:
              DialogLoading.showLoading('connecting');
              break;
            case IvmConnectionStatus.connected:
              var pairingDataHistory =
                  await IvmManager.getInstance().getPairingDataHistory();
              bool isHadId = false;
              if (pairingDataHistory != null && pairingDataHistory.isNotEmpty) {
                var ivmId = pairingDataHistory.last.valveId;
                isHadId = ivmId.isNotEmpty;
              }
              DialogLoading.dismissLoading('connecting');
              _onNext(isHadId, deviceName);
              break;
          }
        }
      },
      child: InkWell(
        onTap: () async {
          if (isDeviceClicked) {
            return;
          }
          isDeviceClicked = true;
          final scanResult =
              await IvmManager.getInstance().startScanWithName(device.name, 8);

          _startConnect(scanResult);
        },
        child: SizedBox(
          width: 343.w,
          height: 56.h,
          child: Stack(
            children: [
              Positioned(
                  top: 10.h,
                  bottom: 27.h,
                  left: 8.w,
                  child: Text(deviceName,
                      style: TextStyle(
                          color: ColorTheme.primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0.sp),
                      textAlign: TextAlign.left)),
              Positioned(
                  top: 30.h,
                  bottom: 10.h,
                  left: 8.w,
                  child: Text(device.location,
                      style: TextStyle(
                          color: ColorTheme.primaryAlpha_50,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0.sp),
                      textAlign: TextAlign.left)),
              Positioned(
                  top: 55.h,
                  left: 0,
                  right: 0,
                  child: Container(
                      width: 343.w,
                      height: 1.h,
                      decoration: const BoxDecoration(
                          color: ColorTheme.primaryAlpha_10)))
            ],
          ),
        ),
      ),
    );
  }

  void _startConnect(ScanResult? scanResult) {
    if (scanResult == null) {
      _showPairFail();
    } else {
      IvmManager.getInstance().stopScan();
      ivmConnectionBloc.add(IvmConnect(scanResult.device));
    }
  }

  void _onNext(bool isHadId, String name) {
    if (isHadId) {
      _showPairedWithId(context, name);
    } else {
      _showPairedWithoutId(context, name);
    }
  }

  void _showPairedWithoutId(BuildContext myContext, String deviceName) {
    SmartDialog.show(
        builder: (context) {
          return DialogWidgetUtil.pairedWithoutIdDialog(myContext, deviceName,
              () {
            SmartDialog.dismiss(tag: 'pair_without_id');
            Navigator.pushNamed(context, kRouteReplaceBallValvePage).then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                    myContext, kRouteActionMenu, (route) => false));
          }, () {
            SmartDialog.dismiss(tag: 'pair_without_id');
            Navigator.pushNamedAndRemoveUntil(
                myContext, kRouteActionMenu, (route) => false);
          });
        },
        tag: 'pair_without_id',
        clickMaskDismiss: false,
        backDismiss: false,
        keepSingle: true);
  }

  void _showPairedWithId(BuildContext myContext, String deviceName) {
    SmartDialog.show(
        builder: (context) {
          return DialogWidgetUtil.pairedWithIdDialog(myContext, deviceName, () {
            SmartDialog.dismiss(tag: 'pair_with_id');
            Navigator.pushNamedAndRemoveUntil(
                myContext, kRouteActionMenu, (route) => false);
          });
        },
        tag: 'pair_with_id',
        clickMaskDismiss: false,
        backDismiss: false,
        keepSingle: true);
  }

  void _showPairFail() {
    SmartDialog.show(
        builder: (context) {
          return DialogWidgetUtil.pairFailDialog(
              context,
              () => {
                    isDeviceClicked = false,
                    SmartDialog.dismiss(tag: 'pair_fail')
                  });
        },
        tag: 'pair_fail');
  }
}
