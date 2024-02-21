import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/src/data/replace_ball_valve.dart';

import '../../../bloc/device_setting/ivm_replace_ball_valve_cubit.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/dialog_widget_util.dart';
import '../../../util/separator_view.dart';

class ReplaceBallValvePage extends StatefulWidget {
  const ReplaceBallValvePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _replaceBallValve();
  }
}

class _replaceBallValve extends State<ReplaceBallValvePage> {
  final idControl = TextEditingController();
  var isUpdateData = false;
  IvmReplaceBallValveCubit ivmReplaceBallValveCubit =
      IvmReplaceBallValveCubit();

  @override
  void initState() {
    super.initState();
    ivmReplaceBallValveCubit.loadReplaceBallValveData();
  }

  @override
  void dispose() {
    ivmReplaceBallValveCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: ivmReplaceBallValveCubit,
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
            return Stack(
              children: [
                _createTitleWidget(context),
                _createBallValveIdSettingsWidget(context, state.data),
                _createSaveButton(context)
              ],
            );
          } else {
            // todo error
            DialogLoading.dismissLoading('loading');
            isUpdateData = false;
            return Container();
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
            top: 46.h,
            left: 4.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 48.w,
                height: 48.h,
              ),
            )),
        Positioned(
            top: 64.h,
            left: 0,
            right: 0,
            child: Text('Replace Ball Valve',
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

  _createBallValveIdSettingsWidget(BuildContext context, ReplaceBallValve data) {
    return Stack(
      children: [
        Positioned(
            top: 112.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              width: 343.w,
              height: 317.h,
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
                      child: Text('Ball Valve ID settings',
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
                          "Enter new Ball Valve ID after replacement for correct data sync.",
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_50,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0.sp),
                          textAlign: TextAlign.left)),
                  Positioned(
                      top: 115.h,
                      left: 16.w,
                      child: SizedBox(
                        width: 311.w,
                        height: 40.h,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Image.asset(
                                  'assets/icon_ivm.png',
                                  width: 40.w,
                                  height: 40.h,
                                )),
                            Positioned(
                                top: 2.h,
                                left: 50.w,
                                child: Text("IVM ID",
                                    style: TextStyle(
                                        color: ColorTheme.primary,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SFProDisplay",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0.sp),
                                    textAlign: TextAlign.left)),
                            Positioned(
                                top: 22.h,
                                left: 50.w,
                                child: Text(data.ivmId,
                                    style: TextStyle(
                                        color: ColorTheme.primaryAlpha_50,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "SFProDisplay",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0.sp),
                                    textAlign: TextAlign.left))
                          ],
                        ),
                      )),
                  Positioned(
                      top: 171.h,
                      left: 16.w,
                      child: SizedBox(
                        width: 311.w,
                        height: 40.h,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Image.asset(
                                  'assets/icon_ball.png',
                                  width: 40.w,
                                  height: 40.h,
                                )),
                            Positioned(
                                top: 2.h,
                                left: 50.w,
                                child: Text("Currrent Ball Valve ID",
                                    style: TextStyle(
                                        color: ColorTheme.primary,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SFProDisplay",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0.sp),
                                    textAlign: TextAlign.left)),
                            Positioned(
                                top: 22.h,
                                left: 50.w,
                                child: Text(data.ballValveId,
                                    style: TextStyle(
                                        color: ColorTheme.primaryAlpha_50,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "SFProDisplay",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0.sp),
                                    textAlign: TextAlign.left))
                          ],
                        ),
                      )),
                  Positioned(
                      top: 227.h,
                      left: 16.w,
                      right: 16.w,
                      child: TextField(
                        controller: idControl,
                        decoration: InputDecoration(
                            labelText: 'New Ball Valve ID',
                            labelStyle: TextStyle(
                                color: ColorTheme.primaryAlpha_35,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0.sp),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorTheme.primaryAlpha_10),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorTheme.primaryAlpha_10),
                            ),
                            filled: true,
                            fillColor: ColorTheme.primaryAlpha_10),
                      )),
                  Positioned(
                      top: 287.h,
                      right: 24.w,
                      child: Text("Factory default: 0",
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
                if (idControl.text.isNotEmpty) {
                  ivmReplaceBallValveCubit.setReplaceBallValveData(idControl.text);
                }
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
                      colors: [
                        ColorTheme.secondaryGradient,
                        ColorTheme.secondary
                      ]),
                ),
                child: Center(
                  child: Text(
                    'Save',
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
