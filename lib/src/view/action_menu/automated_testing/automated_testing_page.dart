import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/route.dart';

import '../../../../generated/l10n.dart';
import '../../../bloc/automated_testing/automated_testing_cubit.dart';
import '../../../data/automated_testing_result.dart';
import '../../../data/enum_util.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/dialog_widget_util.dart';

class AutomatedTestingPage extends StatefulWidget {
  const AutomatedTestingPage({super.key});

  @override
  State<AutomatedTestingPage> createState() => _AutomatedTesting();
}

class _AutomatedTesting extends State<AutomatedTestingPage> {
  AutomatedTestingCubit automatedTestingCubit = AutomatedTestingCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    automatedTestingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _createTitleWidget(context),
        BlocBuilder(
            bloc: automatedTestingCubit,
            builder: (context, state) {
              if (state is Loading) {
                DialogLoading.showLoading('loading',
                    content: 'Automated testing in progress…');
                return _createContentWidget(context, state.result);
              } else if (state is Done) {
                DialogLoading.dismissLoading('loading');
                if (state.result.isSuccess) {
                  SmartDialog.show(
                      builder: (context) {
                        return DialogWidgetUtil.automatedTestingSuccessDialog(
                            context);
                      },
                      tag: 'success');
                  Future.delayed(const Duration(seconds: 3), () {
                    SmartDialog.dismiss(tag: 'success');
                  });
                } else {
                  SmartDialog.show(
                      builder: (context) {
                        return DialogWidgetUtil.automatedTestingFailDialog(
                            context);
                      },
                      tag: 'fail');
                  Future.delayed(const Duration(seconds: 3), () {
                    SmartDialog.dismiss(tag: 'fail');
                  });
                }
                return _createContentWidget(context, state.result);
              }
              return _createContentWidget(
                  context,
                  AutomatedTestingResult(
                    ItemState.init,
                    ItemState.init,
                    ItemState.init,
                    ItemState.init,
                    false,
                  ));
            }),
      ],
    );
  }

  _createContentWidget(BuildContext context, AutomatedTestingResult result) {
    return Positioned(
        top: 112.h,
        left: 16.w,
        right: 16.w,
        bottom: 0,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: _createItemWidget(
                    context, S.of(context).device_settings_valve_position, result.isValvePositionState)),
            Positioned(
                top: 96.h,
                child: _createItemWidget(
                    context, S.of(context).device_settings_valve_torque, result.isValveTorqueState)),
            Positioned(
                top: 192.h,
                child: _createItemWidget(context, S.of(context).device_settings_emission_detection,
                    result.isEmissionDetectionState)),
            Positioned(
                top: 288.h,
                child: _createItemWidget(
                    context, S.of(context).auto_test_ivm_temp, result.isIvmTempState)),
            Positioned(
                bottom: 65.h,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    automatedTestingCubit.startTest();
                  },
                  child: Container(
                    width: 343.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(30.h)),
                      boxShadow: const [
                        BoxShadow(
                            color: ColorTheme.primary,
                            offset: Offset(0, 10),
                            blurRadius: 25,
                            spreadRadius: 0)
                      ],
                      gradient: const LinearGradient(
                          begin: Alignment(0.6116728186607361, 0),
                          end: Alignment(
                              0.37270376086235046, 1.0995962619781494),
                          colors: [
                            ColorTheme.secondaryGradient,
                            ColorTheme.secondary
                          ]),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).fw_update_update,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorTheme.fontColor),
                      ),
                    ),
                  ),
                ))
          ],
        ));
  }

  _createItemWidget(BuildContext context, String title, ItemState state) {
    return Container(
      width: 343.w,
      height: 80.h,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: ColorTheme.primaryAlpha_10,
                offset: Offset(0, 10),
                blurRadius: 30,
                spreadRadius: 0)
          ],
          color: ColorTheme.white),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              child: // light
                  Container(
                      width: 12.w,
                      height: 80.h,
                      decoration:
                          BoxDecoration(color: _getItemStateColor(state)))),
          Positioned(
              left: 24.w,
              top: state == ItemState.fail ? 21.h : 31.h,
              child: Text(title,
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              left: 24.w,
              right: 70.w,
              top: 42.h,
              child: state == ItemState.fail
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(S.of(context).auto_test_device_faulty,
                          style: TextStyle(
                              color: ColorTheme.redAlpha_35,
                              fontWeight: FontWeight.w400,
                              fontFamily: "SFProDisplay",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0.sp),
                          textAlign: TextAlign.left),
                    )
                  : const SizedBox()),
          Positioned(
              top: 31.h,
              right: 16.w,
              child: state != ItemState.init
                  ? Text(state == ItemState.success ? S.of(context).common_pass : S.of(context).common_fail,
                      style: TextStyle(
                          color: state == ItemState.success
                              ? ColorTheme.green
                              : ColorTheme.red,
                          fontWeight: FontWeight.w500,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0.sp),
                      textAlign: TextAlign.right)
                  : Text("－－",
                      style: TextStyle(
                          color: ColorTheme.primaryAlpha_35,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0.sp),
                      textAlign: TextAlign.left))
        ],
      ),
    );
  }

  _getItemStateColor(ItemState state) {
    Color color = ColorTheme.primaryAlpha_35;
    switch (state) {
      case ItemState.init:
        color = ColorTheme.primaryAlpha_35;
      case ItemState.success:
        color = ColorTheme.green;
      case ItemState.fail:
        color = ColorTheme.red;
    }
    return color;
  }

  _createTitleWidget(BuildContext context) {
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
              'assets/header_bg_2.png',
              width: 375.w,
              height: 160.h,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 58.h,
            left: 16.w,
            child: Image.asset(
              'assets/light_3.png',
              width: 24.w,
              height: 24.h,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 42.h,
            left: 0.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 56.w,
                height: 56.h,
              ),
            )),
        Positioned(
            top: 64.h,
            left: 0,
            right: 0,
            child: Text(S.of(context).auto_test,
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
                Navigator.pushNamed(context, kRouteAboutDevicePage);
              },
              child: Image.asset(
                'assets/light_2.png',
                width: 24.w,
                height: 24.h,
              ),
            ))
      ],
    );
  }
}
