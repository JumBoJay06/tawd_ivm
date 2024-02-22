import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawd_ivm/src/manager/data/led_indicator_state.dart';
import 'package:tawd_ivm/src/theme/style.dart';

import '../../generated/l10n.dart';
import '../bloc/led_select_color_cubit.dart';

class DialogWidgetUtil {
  static Widget pairFailDialog(BuildContext context, Function() confirm) {
    return // 矩形
        Container(
      width: 280.w,
      height: 229.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          // icon
          Positioned(
              top: 24.h,
              left: 112.w,
              right: 112.w,
              child: Image.asset('assets/icon_device_fail.png',
                  width: 56.w, height: 56.h)),
          // title
          Positioned(
              top: 96.h,
              left: 0,
              right: 0,
              child: Text(S.of(context).available_device_please_retry,
                  style: const TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 128.h,
              left: 24.w,
              right: 24.w,
              child: Text(S.of(context).available_device_please_retry,
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left)),
          //confirm btn
          Positioned(
              top: 164.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: confirm,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorTheme.secondary),
                  child: Center(
                    child: Text(S.of(context).common_ok,
                        style: const TextStyle(
                            color: ColorTheme.fontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static Widget pairFailDialogForScan(
      BuildContext context, Function() confirm) {
    return // 矩形
        Container(
      width: 280.w,
      height: 229.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          // icon
          Positioned(
              top: 24.h,
              left: 112.w,
              right: 112.w,
              child: Image.asset('assets/icon_device_fail.png',
                  width: 56.w, height: 56.h)),
          // title
          Positioned(
              top: 96.h,
              left: 0,
              right: 0,
              child: Text(S.of(context).available_device_failed,
                  style: const TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 128.h,
              left: 24.w,
              right: 24.w,
              child: Text(S.of(context).available_device_please_retry,
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left)),
          //confirm btn
          Positioned(
              top: 164.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: confirm,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorTheme.secondary),
                  child: Center(
                    child: Text(S.of(context).common_ok,
                        style: const TextStyle(
                            color: ColorTheme.fontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static Widget pairedWithIdDialog(
      BuildContext context, String deviceName, Function() confirm) {
    return // 矩形
        Container(
      width: 280.w,
      height: 229.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          // icon
          Positioned(
              top: 24.h,
              left: 112.w,
              right: 112.w,
              child: Image.asset('assets/icon_device_paired.png',
                  width: 56.w, height: 56.h)),
          // title
          Positioned(
              top: 96.h,
              left: 0,
              right: 0,
              child: const Text('Pairing Successful',
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 128.h,
              left: 24.w,
              right: 24.w,
              child: Text("IVM ID : $deviceName",
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left)),
          //confirm btn
          Positioned(
              top: 164.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: confirm,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorTheme.secondary),
                  child: Center(
                    child: Text(S.of(context).common_action_menu,
                        style: const TextStyle(
                            color: ColorTheme.fontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static Widget pairedWithoutIdDialog(BuildContext context, String deviceName,
      Function() confirm, Function() cancel) {
    return // 矩形
        Container(
      width: 280.w,
      height: 277.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          // icon
          Positioned(
              top: 24.h,
              left: 112.w,
              right: 112.w,
              child: Image.asset('assets/icon_device_paired.png',
                  width: 56.w, height: 56.h)),
          // title
          Positioned(
              top: 96.h,
              left: 0,
              right: 0,
              child: const Text('Pairing Successful',
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 128.h,
              left: 24.w,
              right: 24.w,
              child: Text("IVM ID : $deviceName",
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left)),
          //confirm btn
          Positioned(
              top: 164.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: confirm,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorTheme.secondary),
                  child: const Center(
                    child: Text('Set Ball Valve ID',
                        style: TextStyle(
                            color: ColorTheme.fontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              )),
          //cancel btn
          Positioned(
              top: 212.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: cancel,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border:
                          Border.all(color: ColorTheme.secondary, width: 1)),
                  child: Center(
                    child: Text(S.of(context).common_action_menu,
                        style: const TextStyle(
                            color: ColorTheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static Widget bleOffDialog(
      BuildContext context, Function() confirm, Function() cancel) {
    return Container(
      width: 280.w,
      height: 276.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          //icon
          Positioned(
              top: 24.h,
              left: 112.w,
              right: 112.w,
              child: Image.asset('assets/icon_ble.png',
                  width: 56.w, height: 56.h)),
          //title
          Positioned(
              top: 96.h,
              left: 80.w,
              right: 80.w,
              child: Text(S.of(context).ivm_service_ble_off,
                  style: const TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 128.h,
              left: 24.w,
              right: 24.w,
              child: Text(S.of(context).ivm_service_please_enable_ble,
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left)),
          //confirm btn
          Positioned(
              top: 164.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: confirm,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorTheme.secondary),
                  child: Center(
                    child: Text(S.of(context).common_settings,
                        style: const TextStyle(
                            color: ColorTheme.fontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              )),
          //cancel btn
          Positioned(
              top: 212.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: cancel,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border:
                          Border.all(color: ColorTheme.secondary, width: 1)),
                  child: Center(
                    child: Text(S.of(context).common_cancel,
                        style: const TextStyle(
                            color: ColorTheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static Widget loadingDialog(BuildContext context, String content) {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          Positioned(
            top: 41.h,
            left: 52.w,
            right: 52.w,
            child: _LoadingIcon(),
          ),
          Positioned(
              top: 105.h,
              left: 0,
              right: 0,
              child: Text(content,
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.center))
        ],
      ),
    );
  }

  static Widget temperatureAbnormal(
      BuildContext context, String deviceName, Function() confirm) {
    return Container(
      width: 280.w,
      height: 306.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          // icon
          Positioned(
              top: 24.h,
              left: 112.w,
              right: 112.w,
              child: Image.asset('assets/icon_worring.png',
                  width: 56.w, height: 56.h)),
          // title
          Positioned(
              top: 96.h,
              left: 0,
              right: 0,
              child: const Text('Temp. Abnormal',
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 128.h,
              left: 24.w,
              right: 24.w,
              child: Text(
                  "IVM ID : $deviceName\n\nThe machine temperature is higher than normal. Please contact the manufacturer.",
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left)),
          //confirm btn
          Positioned(
              top: 242.h,
              left: 24.w,
              right: 24.w,
              child: GestureDetector(
                onTap: confirm,
                child: Container(
                  width: 232,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorTheme.secondary),
                  child: Center(
                    child: Text(S.of(context).common_ok,
                        style: const TextStyle(
                            color: ColorTheme.fontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static Widget aboutDeviceRefreshedDialog(BuildContext context) {
    return _normalHintDialog(
        context,
        'assets/icon_title_renew_confirm.png',
        S.of(context).about_device_date_refreshed,
        S.of(context).about_device_info_newest);
  }

  static Widget aboutDeviceRefreshFailDialog(BuildContext context) {
    return _normalHintDialog(context, 'assets/icon_title_fail.png',
        S.of(context).about_device_refreshed_failed, 'Please retry.');
  }

  static Widget deviceSettingSuccessDialog(BuildContext context) {
    return _normalHintDialog(
        context,
        'assets/icon_title_confirm.png',
        'Save Successfully',
        'Setting is saved.');
  }

  static Widget deviceSettingFailDialog(BuildContext context) {
    return _normalHintDialog(
        context,
        'assets/icon_title_fail.png',
        'Save Failed',
        'Please retry.');
  }

  static Widget ivmConnectedDialog(BuildContext context) {
    return _normalHintDialog(
        context,
        'assets/icon_device_paired.png',
        'IVM Connected!',
        '');
  }

  static Widget automatedTestingSuccessDialog(BuildContext context) {
    return _normalHintDialog(
        context,
        'assets/icon_title_confirm.png',
        'Test Completed',
        'Up-to-date status.');
  }

  static Widget automatedTestingFailDialog(BuildContext context) {
    return _normalHintDialog(
        context,
        'assets/icon_title_fail.png',
        'Automated Testing Failed',
        'Please retry.');
  }

  static Widget _normalHintDialog(
      BuildContext context, String iconAsset, String title, String content) {
    return Container(
      width: 240.w,
      height: 201.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          Positioned(
              top: 24.h,
              left: 76.w,
              right: 76.w,
              child: Image.asset(
                iconAsset,
                width: 88.w,
                height: 88.h,
                fit: BoxFit.fill,
              )),
          // title
          Positioned(
              top: 128.h,
              left: 0,
              right: 0,
              child: Text(title,
                  style: const TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center)),
          //content
          Positioned(
              top: 160.h,
              left: 0,
              right: 0,
              child: Text(content,
                  style: const TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  static Widget ledIndicatorSelect(String title, LedColor color,
      Function(LedColor) confirm, Function() cancel) {
    LedSelectColorCubit ledSelectColorCubit = LedSelectColorCubit();
    ledSelectColorCubit.initColor(color);
    return BlocBuilder(
        bloc: ledSelectColorCubit,
        builder: (context, state) {
          if (state is OnChange) {
            return Container(
              width: 280.w,
              height: 296.h,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: ColorTheme.white),
              child: Stack(
                children: [
                  Positioned(
                      top: 24.h,
                      left: 24.w,
                      child: Text(title,
                          style: const TextStyle(
                              color: ColorTheme.primary,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0),
                          textAlign: TextAlign.left)),
                  //藍
                  Positioned(
                      top: 56.h,
                      left: 24.w,
                      child: GestureDetector(
                        onTap: () {
                          ledSelectColorCubit.clickColor(LedColor.blue);
                        },
                        child: SizedBox(
                          width: 52.w,
                          height: 52.h,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                              color: const Color(0xff95989a),
                                              width: 1),
                                          color: ColorTheme.blue))),
                              Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: state.selectIndex == LedColor.blue.id
                                      ? Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color(0x1f000000)),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/check_icon.png',
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        )
                                      : const SizedBox())
                            ],
                          ),
                        ),
                      )),
                  //靛青
                  Positioned(
                      top: 56.h,
                      left: 84.w,
                      child: GestureDetector(
                        onTap: () {
                          ledSelectColorCubit.clickColor(LedColor.cyan);
                        },
                        child: SizedBox(
                          width: 52.w,
                          height: 52.h,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                              color: const Color(0xff95989a),
                                              width: 1),
                                          color: ColorTheme.cyan))),
                              Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: state.selectIndex == LedColor.cyan.id
                                      ? Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color(0x1f000000)),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/check_icon.png',
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        )
                                      : const SizedBox())
                            ],
                          ),
                        ),
                      )),
                  //綠
                  Positioned(
                      top: 56.h,
                      left: 144.w,
                      child: GestureDetector(
                        onTap: () {
                          ledSelectColorCubit.clickColor(LedColor.green);
                        },
                        child: SizedBox(
                          width: 52.w,
                          height: 52.h,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                              color: const Color(0xff95989a),
                                              width: 1),
                                          color: ColorTheme.green))),
                              Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: state.selectIndex == LedColor.green.id
                                      ? Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color(0x1f000000)),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/check_icon.png',
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        )
                                      : const SizedBox())
                            ],
                          ),
                        ),
                      )),
                  //洋紅
                  Positioned(
                      top: 56.h,
                      left: 204.w,
                      child: GestureDetector(
                        onTap: () {
                          ledSelectColorCubit.clickColor(LedColor.magenta);
                        },
                        child: SizedBox(
                          width: 52.w,
                          height: 52.h,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                              color: const Color(0xff95989a),
                                              width: 1),
                                          color: ColorTheme.magenta))),
                              Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: state.selectIndex ==
                                          LedColor.magenta.id
                                      ? Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color(0x1f000000)),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/check_icon.png',
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        )
                                      : const SizedBox())
                            ],
                          ),
                        ),
                      )),
                  //白
                  Positioned(
                      top: 116.h,
                      left: 24.w,
                      child: GestureDetector(
                        onTap: () {
                          ledSelectColorCubit.clickColor(LedColor.white);
                        },
                        child: SizedBox(
                          width: 52.w,
                          height: 52.h,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                              color: const Color(0xff95989a),
                                              width: 1),
                                          color: ColorTheme.white))),
                              Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: state.selectIndex == LedColor.white.id
                                      ? Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color(0x1f000000)),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/check_icon.png',
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        )
                                      : const SizedBox())
                            ],
                          ),
                        ),
                      )),
                  //黃
                  Positioned(
                      top: 116.h,
                      left: 84.w,
                      child: GestureDetector(
                        onTap: () {
                          ledSelectColorCubit.clickColor(LedColor.yellow);
                        },
                        child: SizedBox(
                          width: 52.w,
                          height: 52.h,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          border: Border.all(
                                              color: const Color(0xff95989a),
                                              width: 1),
                                          color: ColorTheme.yellow))),
                              Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: state.selectIndex == LedColor.yellow.id
                                      ? Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color(0x1f000000)),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/check_icon.png',
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        )
                                      : const SizedBox())
                            ],
                          ),
                        ),
                      )),
                  //confirm btn
                  Positioned(
                      top: 184.h,
                      left: 24.w,
                      right: 24.w,
                      child: GestureDetector(
                        onTap: () {
                          confirm(LedColor.fromInt(state.selectIndex));
                        },
                        child: Container(
                          width: 232.w,
                          height: 40.h,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: ColorTheme.secondary),
                          child: Center(
                            child: Text(S.of(context).common_settings,
                                style: const TextStyle(
                                    color: ColorTheme.fontColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      )),
                  //cancel btn
                  Positioned(
                      top: 232.h,
                      left: 24.w,
                      right: 24.w,
                      child: GestureDetector(
                        onTap: cancel,
                        child: Container(
                          width: 232.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: ColorTheme.secondary, width: 1)),
                          child: Center(
                            child: Text(S.of(context).common_cancel,
                                style: const TextStyle(
                                    color: ColorTheme.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ))
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  static Widget ivmDisconnected(
      BuildContext context, Function() confirm) {
    return // 矩形
      Container(
        width: 280.w,
        height: 229.h,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: ColorTheme.white),
        child: Stack(
          children: [
            // icon
            Positioned(
                top: 24.h,
                left: 112.w,
                right: 112.w,
                child: Image.asset('assets/icon_device_fail.png',
                    width: 56.w, height: 56.h)),
            // title
            Positioned(
                top: 96.h,
                left: 0,
                right: 0,
                child: const Text('IVM Disconnected',
                    style: TextStyle(
                        color: ColorTheme.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.center)),
            //confirm btn
            Positioned(
                top: 164.h,
                left: 24.w,
                right: 24.w,
                child: GestureDetector(
                  onTap: confirm,
                  child: Container(
                    width: 232,
                    height: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: ColorTheme.secondary),
                    child: Center(
                      child: Text(S.of(context).common_ok,
                          style: const TextStyle(
                              color: ColorTheme.fontColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ))
          ],
        ),
      );
  }
}

class _LoadingIcon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingIconState();
  }
}

class _LoadingIconState extends State<_LoadingIcon>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat();

  final Tween<double> turnsTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.w,
      height: 56.h,
      child: Center(
        child: RotationTransition(
          turns: turnsTween.animate(_controller),
          child: Image.asset(
            'assets/icon_title_loading.png',
            width: 56.w,
            height: 56.h,
          ),
        ),
      ),
    );
  }
}
