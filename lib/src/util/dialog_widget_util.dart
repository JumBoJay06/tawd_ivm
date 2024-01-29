import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawd_ivm/src/theme/style.dart';

import '../../generated/l10n.dart';

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

  static Widget pairFailDialogForScan(BuildContext context, Function() confirm) {
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

  static Widget pairedWithIdDialog(BuildContext context, String deviceName,
      Function() confirm) {
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
