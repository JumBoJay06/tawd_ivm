import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawd_ivm/src/theme/style.dart';

import '../../generated/l10n.dart';

class DialogUtil {
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
                      color: ColorTheme.primaryAlpha_7f,
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
}
