import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_connection_bloc.dart';
import 'package:tawd_ivm/src/bloc/paired_device/paired_device_bloc.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/util/dialog_loading.dart';

import '../../../generated/l10n.dart';
import '../../bloc/device_text_field/device_text_field_bloc.dart';
import '../../data/paired_device.dart';
import '../../theme/style.dart';
import '../../util/dialog_widget_util.dart';

/// 用Bloc實作撈取DB與查詢，並有已配對裝置與無裝置兩種狀態
/// 另外 bloc 要暫存已配對裝置，方便過濾與還原
class PairedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PairedPage();
  }
}

class _PairedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _createTitleWidget(context),
        Positioned(
            top: 100.h,
            child: BlocBuilder<PairedDeviceBloc, PairedDeviceState>(
                builder: (context, state) {
              if (state.deviceList.isEmpty) {
                return _createEmptyDeviceListWidget(context);
              } else {}
              return Container();
            }))
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
                Navigator.pop(context);
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
            child: const Text('Paired Device',
                style: TextStyle(
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
                context.read<DeviceTextFieldBloc>().add(StopFilter());
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
                Navigator.pop(context);
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
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  color: ColorTheme.white),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  onChanged: (filter) {
                    context.read<PairedDeviceBloc>().add(Filter(filter));
                  },
                  decoration: const InputDecoration(
                      hintText: 'Enter device number for quick search',
                      hintStyle: TextStyle(
                          color: ColorTheme.primaryAlpha_20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0)),
                ),
              ),
            )),
        Positioned(
            top: 62.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                context.read<DeviceTextFieldBloc>().add(StopFilter());
              },
              child: Text(S.of(context).common_cancel,
                  style: const TextStyle(
                      color: ColorTheme.fontColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.right),
            ))
      ],
    );
  }

  Widget _createEmptyDeviceListWidget(BuildContext context) {
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
                  child: Text(
                      S.of(context).available_device_no_paired_device_content,
                      style: const TextStyle(
                          color: ColorTheme.primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 24.0),
                      textAlign: TextAlign.center)),
              Positioned(
                  top: 353.h,
                  left: 0,
                  right: 0,
                  child: Text(
                      S
                          .of(context)
                          .available_device_please_connect_first_content,
                      style: const TextStyle(
                          color: ColorTheme.primaryAlpha_50,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left))
            ],
          ),
        ));
  }

  Widget _createDeviceListWidget(
      BuildContext context, List<PairedDevice> deviceList) {
    return Stack(
      children: [
        Positioned(
            top: 24.h,
            left: 16.w,
            child: Text(
                S.of(context).available_device_show_devices_paired_content,
                style: const TextStyle(
                    color: ColorTheme.secondary,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left)),
        Positioned(
            top: 8.h,
            left: 16.w,
            right: 16.w,
            child: ListView.builder(
                itemCount: deviceList.length,
                itemBuilder: (BuildContext context, int index) =>
                    _createListItem(context, deviceList[index])))
      ],
    );
  }

  Widget _createListItem(BuildContext context, PairedDevice device) {
    return InkWell(
      onTap: () async {
        BlocListener<IvmConnectionBloc, IvmConnectionState>(
            listener: (context, state) {
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
                DialogLoading.dismissLoading('connecting');
                _showPairedWithId(device.name);
                break;
            }
          }
        });

        final scanResult =
            await IvmManager.getInstance().startScanWithName(device.name, 8);

        if (scanResult == null) {
          _showPairFail();
        } else {
          context.read<IvmConnectionBloc>().add(IvmConnect(scanResult.device));
        }
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
                child: Text(device.name,
                    style: const TextStyle(
                        color: ColorTheme.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SFProDisplay",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left)),
            Positioned(
                top: 30.h,
                bottom: 10.h,
                left: 8.w,
                child: Text(device.location,
                    style: const TextStyle(
                        color: ColorTheme.primaryAlpha_50,
                        fontWeight: FontWeight.w400,
                        fontFamily: "SFProDisplay",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left)),
            Positioned(
                top: 55.h,
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
    );
  }

  void _showPairedWithId(String deviceName) {
    SmartDialog.show(
        builder: (context) {
          return DialogWidgetUtil.pairedWithIdDialog(
              context,
              deviceName,
              () => {
                    // todo goto action menu
                  });
        },
        tag: 'pair_with_id');
  }

  void _showPairFail() {
    SmartDialog.show(
        builder: (context) {
          return DialogWidgetUtil.pairFailDialog(
              context, () => {SmartDialog.dismiss(tag: 'pair_fail')});
        },
        tag: 'pair_fail');
  }
}
