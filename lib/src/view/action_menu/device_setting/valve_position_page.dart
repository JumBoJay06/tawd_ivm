import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/data/valve_position.dart';

import '../../../../generated/l10n.dart';
import '../../../bloc/device_setting/ivm_valve_position_cubit.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/dialog_widget_util.dart';
import '../../../util/separator_view.dart';

class ValvePositionPage extends StatefulWidget {
  const ValvePositionPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _valvePosition();
  }
}

class _valvePosition extends State<ValvePositionPage> {
  Logger get _logger => Logger("ValvePositionPage");
  var isUpdateData = false;
  var textFieldHeight = 0.0;
  var isFirstTime = true;
  final minControl = TextEditingController(text: '0');
  final maxControl = TextEditingController(text: '0');

  IvmValvePositionCubit ivmValvePositionCubit = IvmValvePositionCubit();

  @override
  void initState() {
    super.initState();
    ivmValvePositionCubit.loadValvePositionData();
  }

  @override
  void dispose() {
    ivmValvePositionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardPadding > 0) {
      if (keyboardPadding > textFieldHeight) {
        keyboardPadding = keyboardPadding - textFieldHeight;
      } else {
        keyboardPadding = 0;
      }
    }
    return BlocBuilder(
      bloc: ivmValvePositionCubit,
        builder: (context, state) {
      if (state is Loading) {
        DialogLoading.showLoading('loading', content: 'loading');
        return Container();
      } else if (state is Success) {
        DialogLoading.dismissLoading('loading');
        if (isUpdateData) {
          isUpdateData = false;
          SmartDialog.show(builder: (context) {
            return DialogWidgetUtil.deviceSettingSuccessDialog(context);
          }, tag: 'success');
          Future.delayed(const Duration(seconds: 3), () {
            SmartDialog.dismiss(tag: 'success');
          });
        }
        if (isFirstTime) {
          isFirstTime = false;
          maxControl.text = state.data.max.toString();
          minControl.text = state.data.min.toString();
        }
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardPadding),
                child: SizedBox(
                  width: 375.w,
                  height: 812.h,
                  child: Stack(
                    children: [
                      _createTitleWidget(context),
                      _createAlertValueSettingWidget(context),
                      _createSaveButton(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        // todo error
        if (state is Fail) {
          _logger.shout('${state.e}');
        }
        DialogLoading.dismissLoading('loading');
        isUpdateData = false;
        isFirstTime = true;
        SmartDialog.show(builder: (context) {
          return DialogWidgetUtil.deviceSettingFailDialog(context);
        }, tag: 'fail');
        Future.delayed(const Duration(seconds: 3), () {
          SmartDialog.dismiss(tag: 'fail');
          ivmValvePositionCubit.loadValvePositionData();
        });
        return Container(color: ColorTheme.background,);
      }
    });
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
            bottom: 728.h,
            left: 56.w,
            right: 56.w,
            child: Text(S.of(context).device_settings_valve_position,
                style: TextStyle(
                    color: ColorTheme.fontColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0.sp),
                textAlign: TextAlign.center)),
      ],
    );
  }

  _createAlertValueSettingWidget(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 112.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              width: 343.w,
              height: 304.h,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: ColorTheme.secondaryAlpha_10,
                        offset: Offset(0, 10),
                        blurRadius: 30,
                        spreadRadius: 0)
                  ],
                  color: ColorTheme.white),
              child: Stack(
                children: [
                  Positioned(
                      top: 18.h,
                      left: 16.w,
                      child: Text(S.of(context).device_settings_alert_value,
                          style: TextStyle(
                              color: ColorTheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SFProDisplay",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0.sp),
                          textAlign: TextAlign.left)),
                  Positioned(
                      top: 48.h,
                      left: 0,
                      right: 0,
                      child: SeparatorView(
                        height: 1.h,
                        dashWidth: 5.w,
                        color: ColorTheme.primaryAlpha_50,
                      )),
                  Positioned(
                      top: 61.h,
                      left: 16.w,
                      right: 16.w,
                      child: Text(
                          S.of(context).device_settings_angle_setting_content,
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_50,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0.sp),
                          textAlign: TextAlign.left)),
                  Positioned(
                      top: 132.h,
                      left: 16.w,
                      right: 16.w,
                      child: TextField(
                        controller: minControl,
                        keyboardType: TextInputType.number,
                        onTap: () {
                          textFieldHeight = 494.h;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            ivmValvePositionCubit.setValvePositionMin(int.parse(value));
                          } else {
                            ivmValvePositionCubit.setValvePositionMin(0);
                          }
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            labelText: S.of(context).device_settings_min,
                            labelStyle: TextStyle(
                                color: ColorTheme.primaryAlpha_35,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0.sp),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            filled: true,
                            fillColor: ColorTheme.primary.withOpacity(0.035)),
                      )),
                  Positioned(
                      top: 192.h,
                      right: 24.w,
                      child: Text("${S.of(context).device_settings_factory_default}: 0",
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_35,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0.sp),
                          textAlign: TextAlign.right)),
                  Positioned(
                      top: 214.h,
                      left: 16.w,
                      right: 16.w,
                      child: TextField(
                        controller: maxControl,
                        keyboardType: TextInputType.number,
                        onTap: () {
                          textFieldHeight = 412.h;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            ivmValvePositionCubit.setValvePositionMax(int.parse(value));
                          } else {
                            ivmValvePositionCubit.setValvePositionMax(0);
                          }
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            labelText: S.of(context).device_settings_max,
                            labelStyle: TextStyle(
                                color: ColorTheme.primaryAlpha_35,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0.sp),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            filled: true,
                            fillColor: ColorTheme.primary.withOpacity(0.035)),
                      )),
                  Positioned(
                      top: 274.h,
                      right: 24.w,
                      child: Text("${S.of(context).device_settings_factory_default}: 90",
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_35,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0.sp),
                          textAlign: TextAlign.right)),
                ],
              ),
            ))
      ],
    );
  }

  _createSaveButton(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 708.h,
            left: 16.w,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                isUpdateData = true;
                ivmValvePositionCubit.setValvePositionData(ValvePosition(
                    int.parse(maxControl.text), int.parse(minControl.text)));
              },
              child: Container(
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
                      colors: [
                        ColorTheme.secondaryGradient,
                        ColorTheme.secondary
                      ]),
                ),
                child: Center(
                  child: Text(
                    S.of(context).common_save,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorTheme.fontColor),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
