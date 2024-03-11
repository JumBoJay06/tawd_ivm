import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/bloc/device_setting/ivm_device_location_cubit.dart';

import '../../../../generated/l10n.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/dialog_widget_util.dart';
import '../../../util/separator_view.dart';

class DeviceLocationPage extends StatefulWidget {
  const DeviceLocationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _deviceLocation();
  }

}

class _deviceLocation extends State<DeviceLocationPage> {
  Logger get _logger => Logger("ValvePositionPage");
  var isUpdateData = false;
  final locationControl = TextEditingController();
  IvmDeviceLocationCubit ivmDeviceLocationCubit = IvmDeviceLocationCubit();


  @override
  void initState() {
    super.initState();
    ivmDeviceLocationCubit.loadDeviceLocationData();
  }


  @override
  void dispose() {
    ivmDeviceLocationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc:  ivmDeviceLocationCubit,
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
            locationControl.text = state.data;
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Stack(
                children: [
                  _createTitleWidget(context),
                  _createLocationSettingWidget(context),
                  _createSaveButton(context)
                ],
              ),
            );
          } else {
            // todo error
            if (state is Fail) {
              _logger.shout('${state.e}');
            }
            DialogLoading.dismissLoading('loading');
            isUpdateData = false;
            SmartDialog.show(builder: (context) {
              return DialogWidgetUtil.deviceSettingFailDialog(context);
            }, tag: 'fail');
            Future.delayed(const Duration(seconds: 3), () {
              SmartDialog.dismiss(tag: 'fail');
              ivmDeviceLocationCubit.loadDeviceLocationData();
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
            child: Text(S.of(context).device_settings_device_lacation,
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

  _createLocationSettingWidget(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 112.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              width: 343.w,
              height: 204.h,
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
                      child: Text('Location description',
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
                          S.of(context).device_settings_device_lacation_content,
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
                      right: 16.w,
                      child: TextField(
                        controller: locationControl,
                        maxLines: 2,
                        maxLength: 50,
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primaryAlpha_35),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primaryAlpha_35),
                            ),
                            hintText: S.of(context).device_settings_add_description,
                            hintStyle: TextStyle(
                                color: ColorTheme.primaryAlpha_35,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle:  FontStyle.normal,
                                fontSize: 16.0.sp
                            ),
                            filled: true,
                            fillColor: ColorTheme.primaryAlpha_10),
                      )),
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
                if (locationControl.text.isNotEmpty) {
                  isUpdateData = true;
                  ivmDeviceLocationCubit.setDeviceLocationData(locationControl.text);
                }
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