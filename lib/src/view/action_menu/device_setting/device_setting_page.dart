import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/bloc/device_setting/ivm_device_setting_cubit.dart';

import '../../../../route.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/separator_view.dart';

class DeviceSettingPage extends StatefulWidget {
  const DeviceSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _deviceSetting();
  }
}

class _deviceSetting extends State<DeviceSettingPage> {
  Logger get _logger => Logger("DeviceSettingPage");
  IvmDeviceSettingCubit ivmDeviceSettingCubit = IvmDeviceSettingCubit();

  @override
  void dispose() {
    ivmDeviceSettingCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    ivmDeviceSettingCubit.loadDeviceSettingTitle(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_createTitleWidget(context), _createContentWidget(context)],
    );
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
            child: Text('Device Settings',
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

  _createContentWidget(BuildContext context) {
    return BlocBuilder<IvmDeviceSettingCubit, IvmDeviceSettingState>(
        bloc: ivmDeviceSettingCubit,
        builder: (context, state) {
          if (state is Loading) {
            DialogLoading.showLoading('loading', content: 'loading');
            return Container();
          } else if (state is Success) {
            DialogLoading.dismissLoading('loading');
            var data = state.data;
            return Positioned(
                top: 112.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  width: 343.w,
                  height: 486.h,
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
                          child: Text('Setting item',
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
                          top: 49.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, kRouteValveTorquePage)
                                  .then((value) => {
                                        ivmDeviceSettingCubit
                                            .loadDeviceSettingTitle(context)
                                      });
                            },
                            child: _createItemWithContentWidget(
                                data.valveTorque.iconAsset,
                                data.valveTorque.title,
                                data.valveTorque.content1!,
                                data.valveTorque.content2!),
                          )),
                      Positioned(
                          top: 122.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, kRouteEmissionDetectionPage)
                                  .then((value) => {
                                        ivmDeviceSettingCubit
                                            .loadDeviceSettingTitle(context)
                                      });
                            },
                            child: _createItemWithContentWidget(
                                data.emissionDetection.iconAsset,
                                data.emissionDetection.title,
                                data.emissionDetection.content1!,
                                data.emissionDetection.content2!),
                          )),
                      Positioned(
                          top: 195.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, kRouteValvePositionPage)
                                  .then((value) => {
                                        ivmDeviceSettingCubit
                                            .loadDeviceSettingTitle(context)
                                      });
                            },
                            child: _createItemWithContentWidget(
                                data.valvePosition.iconAsset,
                                data.valvePosition.title,
                                data.valvePosition.content1!,
                                data.valvePosition.content2!),
                          )),
                      Positioned(
                          top: 268.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, kRouteDeviceLocationPage)
                                  .then((value) => {
                                        ivmDeviceSettingCubit
                                            .loadDeviceSettingTitle(context)
                                      });
                            },
                            child: _createItemWidget(
                                data.deviceLocation.iconAsset,
                                data.deviceLocation.title),
                          )),
                      Positioned(
                          top: 341.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, kRouteLedIndicatorPage)
                                  .then((value) => ivmDeviceSettingCubit
                                      .loadDeviceSettingTitle(context));
                            },
                            child: _createItemWidget(
                                data.ledIndicator.iconAsset,
                                data.ledIndicator.title),
                          )),
                      Positioned(
                          top: 414.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                      context, kRouteReplaceBallValvePage)
                                  .then((value) => ivmDeviceSettingCubit
                                      .loadDeviceSettingTitle(context));
                            },
                            child: _createItemWidget(
                                data.replaceBallValve.iconAsset,
                                data.replaceBallValve.title),
                          )),
                      _createDividerWidget(),
                    ],
                  ),
                ));
          } else {
            // todo error
            if (state is Fail) {
              _logger.shout("${state.e}");
            }
            DialogLoading.dismissLoading('loading');
            return Container();
          }
        });
  }

  _createItemWidget(String iconAsset, String title) {
    return SizedBox(
      width: 343.w,
      height: 72.h,
      child: Stack(
        children: [
          Positioned(
              top: 16.h,
              left: 16.w,
              child: Image.asset(
                iconAsset,
                width: 40.w,
                height: 40.h,
              )),
          Positioned(
              top: 27.h,
              left: 66.w,
              child: Text(title,
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 0,
              bottom: 0,
              right: 16.w,
              child: Image.asset(
                'assets/icon_arrow.png',
                width: 16.w,
                height: 16.h,
              ))
        ],
      ),
    );
  }

  _createItemWithContentWidget(
      String iconAsset, String title, String content1, String content2) {
    return SizedBox(
      width: 343.w,
      height: 72.h,
      child: Stack(
        children: [
          Positioned(
              top: 16.h,
              left: 16.w,
              child: Image.asset(
                iconAsset,
                width: 40.w,
                height: 40.h,
              )),
          Positioned(
              top: 16.h,
              left: 66.w,
              child: Text(title,
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 42.h,
              left: 66.w,
              child: Image.asset(
                'assets/icon_dot_green.png',
                width: 10.w,
                height: 10.h,
                fit: BoxFit.fill,
              )),
          Positioned(
              top: 36.h,
              left: 78.w,
              child: Text(content1,
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 42.h,
              left: 172.w,
              child: Image.asset(
                'assets/icon_dot_green.png',
                width: 10.w,
                height: 10.h,
                fit: BoxFit.fill,
              )),
          Positioned(
              top: 36.h,
              left: 184.w,
              child: Text(content2,
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 0,
              bottom: 0,
              right: 16.w,
              child: Image.asset(
                'assets/icon_arrow.png',
                width: 16.w,
                height: 16.h,
              ))
        ],
      ),
    );
  }

  _createDividerWidget() {
    return Stack(
      children: [
        Positioned(
            top: 121.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 194.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 267.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 340.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 413.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
      ],
    );
  }
}
