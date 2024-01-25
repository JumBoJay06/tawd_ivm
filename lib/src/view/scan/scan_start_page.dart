import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/src/theme/style.dart';
import 'package:tawd_ivm/src/util/dialog_util.dart';

import '../../../generated/l10n.dart';
import '../../../route.dart';

class ScanStartPage extends StatelessWidget {
  const ScanStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 375.w,
          height: 812.h,
          color: ColorTheme.primary,
        ),
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
            child: Text(S.of(context).ivm_service,
                style: const TextStyle(
                    color: ColorTheme.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center)),
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
                if (!isOn) {
                  _openBleOffDialog();
                } else {
                  // todo scan page
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
                if (!isOn) {
                  _openBleOffDialog();
                } else {
                  // todo goto pair page
                }
              },
              child: _createPairedDeviceWidget(context),
            ))
      ],
    );
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
              child: Text(S.of(context).ivm_service_device_connect,
                  style: const TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0),
                  textAlign: TextAlign.center)),
          Positioned(
              top: 293.h,
              left: 244.w,
              right: 71.w,
              child: Image.asset(
                'assets/icon_arrow_dark.png',
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
          S.of(context).ivm_service_paired_device,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorTheme.fontColor),
        ),
      ),
    );
  }

  Future<bool> _checkBle() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  void _openBleOffDialog() {
    SmartDialog.show(
        tag: 'ble_off',
        builder: (context) {
          return DialogUtil.bleOffDialog(context, () {
            AppSettings.openAppSettings(
                type: AppSettingsType.bluetooth);
            SmartDialog.dismiss(tag: 'ble_off');
          }, () => {SmartDialog.dismiss(tag: 'ble_off')});
        });
  }
}
