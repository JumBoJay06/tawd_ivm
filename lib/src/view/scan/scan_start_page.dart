import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tawd_ivm/src/theme/style.dart';
import 'package:tawd_ivm/src/util/dialog_loading.dart';
import 'package:tawd_ivm/src/util/dialog_widget_util.dart';

import '../../../generated/l10n.dart';
import '../../../route.dart';

class ScanStartPage extends StatelessWidget {
  const ScanStartPage({super.key});

  Logger get _logger => Logger("ScanStartPage");

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Navigator.pushNamedAndRemoveUntil(
              context, kRouteSelectLanguage, (route) => false);
        },
        child: Stack(
      children: [
        Container(
          width: 375.w,
          height: 812.h,
          color: ColorTheme.primary,
        ),
        Positioned(
            left: 0,
            bottom: 14.h,
            child: Container(
                width: 294.00421142578125.w,
                height: 424.26416015625.h,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(154)
                    ),
                    gradient: RadialGradient(colors: [
                      ColorTheme.primaryVariant,
                      ColorTheme.mask
                    ])
                )
            )),
        Positioned(child: Container(
            width: 193.5634765625.w,
            height: 193.5634765625.h,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(180)
                ),
                gradient: RadialGradient(colors: [
                  ColorTheme.primaryVariant,
                  ColorTheme.mask
                ])
            )
        )),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/header_bg_2.png',
              width: 375.w,
              height: 160.h,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 64.h,
            left: 131.w,
            right: 131.w,
            bottom: 728.h,
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(S.of(context).ivm_service,
                    style: TextStyle(
                        color: ColorTheme.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Helvetica",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0.sp),
                    textAlign: TextAlign.center)
            )),
        Positioned(
            top: 58.h,
            left: 335.w,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, kRouteSelectLanguage, (route) => false);
              },
              child: Image.asset(
                'assets/light_14.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.fill,
              ),
            )),
        Positioned(
            top: 112.h,
            left: 16.w,
            right: 16.w,
            child: GestureDetector(
              onTap: () async {
                final isOn = await _checkBle();
                if (!isOn && !Platform.isIOS) {
                  _openBleOffDialog();
                } else {
                  _requestBlePermissions().then((value) {
                    if (value) {
                      Navigator.pushNamed(context, kRouteAvailableDevicesPage);
                    } else {
                      _openBleOffDialog();
                    }
                  });
                }
              },
              child: _createConnectDeviceWidget(context),
            )),
        Positioned(
            bottom: 48.h,
            left: 16.w,
            right: 16.w,
            child: GestureDetector(
              onTap: () async {
                final isOn = await _checkBle();
                if (!isOn && !Platform.isIOS) {
                  _openBleOffDialog();
                } else {
                  _requestBlePermissions().then((value) {
                    if (value) {
                      Navigator.pushNamed(context, kRoutePairedPage);
                    } else {
                      _openBleOffDialog();
                    }
                  });
                }
              },
              child: _createPairedDeviceWidget(context),
            )),
      ],
    ));
  }

  Widget _createConnectDeviceWidget(BuildContext context) {
    return Container(
      width: 343.w,
      height: 480.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.h)),
          image: const DecorationImage(
            image: AssetImage('assets/ic_connect_device_btn.png'),
            fit: BoxFit.fill,
          ),
          color: ColorTheme.white),
      child: Stack(
        children: [
          Positioned(
              top: 100.h,
              left: 51.w,
              right: 51.w,
              child: Image.asset(
                "assets/background_round.png",
                width: 240.w,
                height: 185.h,
              )),
          Positioned(
              top: 140.h,
              left: 99.w,
              right: 99.w,
              child: Image.asset(
                'assets/icon_device_connect.png',
                width: 145.w,
                height: 145.h,
              )),
          Positioned(
              top: 292.h,
              left: 70.w,
              right: 107.w,
              bottom: 159.2.h,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(S.of(context).ivm_service_device_connect,
                    style: TextStyle(
                        color: ColorTheme.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SFProDisplay",
                        fontStyle: FontStyle.normal,
                        fontSize: 24.0.sp),
                    textAlign: TextAlign.center))
              ),
          Positioned(
              top: 295.h,
              left: 244.w,
              right: 71.w,
              child: Image.asset(
                'assets/icon_arrow_dark.png',
                fit: BoxFit.fill,
                width: 28.w,
                height: 28.h,
              )),
        ],
      ),
    );
  }

  Widget _createPairedDeviceWidget(BuildContext context) {
    return Container(
      width: 343.w,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.h)),
        boxShadow: const [
          BoxShadow(
              color: ColorTheme.secondaryAlpha_30,
              offset: Offset(0, 10),
              blurRadius: 25,
              spreadRadius: 0)
        ],
        gradient: const LinearGradient(
            begin: Alignment(0.8071713447570801, -0.3236607015132904),
            end: Alignment(0.31717830896377563, 1.3271920680999756),
            colors: [ColorTheme.secondaryGradient, ColorTheme.secondary]),
      ),
      child: Center(
        child: Text(
          S.of(context).ivm_service_paired_device,
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ColorTheme.fontColor),
        ),
      ),
    );
  }

  Future<bool> _requestBlePermissions() async {
    var isBleGranted = await Permission.bluetooth.request();
    _logger.info('checkBlePermissions, isBleGranted=$isBleGranted');
    var isLocationGranted = await Permission.locationWhenInUse.request();
    _logger.info('checkBlePermissions for android, isLocationGranted=$isLocationGranted');
    var isBleScanGranted = await Permission.bluetoothScan.request();
    _logger.info('checkBlePermissions for android, isBleScanGranted=$isBleScanGranted');
    var isBleConnectGranted = await Permission.bluetoothConnect.request();
    _logger
        .info('checkBlePermissions for android, isBleConnectGranted=$isBleConnectGranted');
    var isBleAdvertiseGranted = await Permission.bluetoothAdvertise.request();
    _logger.info(
        'checkBlePermissions for android, isBleAdvertiseGranted=$isBleAdvertiseGranted');

    if (Platform.isIOS) {
      return isBleGranted == PermissionStatus.granted;
    } else {
      return isLocationGranted == PermissionStatus.granted &&
          // isBleGranted == PermissionStatus.granted  &&
          isBleScanGranted == PermissionStatus.granted &&
          isBleConnectGranted == PermissionStatus.granted &&
          isBleAdvertiseGranted == PermissionStatus.granted;
    }
  }

  Future<bool> _checkBle() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  void _openBleOffDialog() {
    SmartDialog.show(
        tag: 'ble_off',
        builder: (context) {
          return DialogWidgetUtil.bleOffDialog(context, () {
            AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
            SmartDialog.dismiss(tag: 'ble_off');
          }, () => {SmartDialog.dismiss(tag: 'ble_off')});
        });
  }
}
