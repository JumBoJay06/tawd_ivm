import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../bloc/device_setting/ivm_led_indicator_cubit.dart';
import '../../../manager/data/led_indicator_state.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/dialog_widget_util.dart';
import '../../../util/separator_view.dart';

class LedIndicatorPage extends StatefulWidget {
  const LedIndicatorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ledIndicator();
  }
}

class _ledIndicator extends State<LedIndicatorPage> {
  IvmLedIndicatorCubit indicatorCubit = IvmLedIndicatorCubit();
  LedIndicatorState? ledIndicatorState;
  var isUpdateData = false;

  @override
  void initState() {
    super.initState();
    indicatorCubit.loadLedIndicatorData();
  }

  @override
  void dispose() {
    indicatorCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _createTitleWidget(context),
        _createLedSettingWidget(context)
      ],
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
            child: Text('LED Indicator',
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

  _createLedSettingWidget(BuildContext context) {
    return BlocBuilder(
        bloc: indicatorCubit,
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
            ledIndicatorState = state.data;
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
                              child: Text('LED setting',
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
                                  "Set different colors for each state (except for fault states) to enhance operational recognition.",
                                  style: TextStyle(
                                      color: ColorTheme.primaryAlpha_50,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Helvetica",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0.sp),
                                  textAlign: TextAlign.left)),
                          Positioned(
                              top: 99.h,
                              left: 16.w,
                              right: 16.w,
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    switch (index) {
                                      case 0:
                                        return _createItemWidget(
                                            context,
                                            'Abnormal / Fault',
                                            'Short flash',
                                            state.data.error,
                                            index,
                                            isErrorLed: true);
                                      case 1:
                                        return _createItemWidget(
                                            context,
                                            'Maintenance notice',
                                            'Long flash',
                                            state.data.maintain,
                                            index);
                                      case 2:
                                        return _createItemWidget(context, 'Valve open',
                                            'Constant', state.data.valveOpen, index);
                                      case 3:
                                        return _createItemWidget(context, 'Valve close',
                                            'Constant', state.data.valveClose, index);
                                      case 4:
                                        return _createItemWidget(
                                            context,
                                            'RS485 disconnected',
                                            'Short flash',
                                            state.data.RS485Disconnect,
                                            index);
                                      case 5:
                                        return _createItemWidget(
                                            context,
                                            'RS485 connected',
                                            'Breathing',
                                            state.data.RS485Connected,
                                            index);
                                      case 6:
                                        return _createItemWidget(
                                            context,
                                            'BLE disconnected',
                                            'Short flash',
                                            state.data.bleDisconnect,
                                            index);
                                      case 7:
                                        return _createItemWidget(
                                            context,
                                            'BLE connected',
                                            'Breathing',
                                            state.data.bleConnected,
                                            index);
                                      default:
                                        return Container();
                                    }
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: 1.h,
                                      color: ColorTheme.primaryAlpha_10,
                                    );
                                  },
                                  itemCount: 8)),
                        ],
                      ),
                    ))
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

  _createItemWidget(BuildContext context, String title, String content,
      LedColor color, int index,
      {bool isErrorLed = false}) {
    return SizedBox(
      width: 331.w,
      height: 72.h,
      child: Stack(
        children: [
          Positioned(
              top: 16.h,
              left: 0,
              child: Text(title,
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 36.h,
              left: 0,
              child: Text(content,
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 0,
              bottom: 0,
              left: isErrorLed ? 4.w : 0,
              child: isErrorLed
                  ? _createErrorLedWidget(context, color)
                  : _createSelectColorWidget(context, title, index, color))
        ],
      ),
    );
  }

  _createErrorLedWidget(BuildContext context, LedColor color) {
    return Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.h)),
            color: color.toColor()),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  width: 32.w,
                  height: 32.h,
                  'assets/icon_light_white.png',
                  fit: BoxFit.fill,
                )),
          ],
        ));
  }

  _createSelectColorWidget(
      BuildContext context, String title, int index, LedColor color) {
    return GestureDetector(
      onTap: () {
        SmartDialog.show(
            builder: (context) {
              return DialogWidgetUtil.ledIndicatorSelect(title, color, (color) {
                SmartDialog.dismiss(tag: 'ledIndicatorSelect');
                if (ledIndicatorState != null) {
                  isUpdateData = true;
                  switch (index) {
                    case 1:
                      ledIndicatorState!.maintain = color;
                      break;
                    case 2:
                      ledIndicatorState!.valveOpen = color;
                      break;
                    case 3:
                      ledIndicatorState!.valveClose = color;
                      break;
                    case 4:
                      ledIndicatorState!.RS485Disconnect = color;
                      break;
                    case 5:
                      ledIndicatorState!.RS485Connected = color;
                      break;
                    case 6:
                      ledIndicatorState!.bleDisconnect = color;
                      break;
                    case 7:
                      ledIndicatorState!.bleConnected = color;
                      break;
                  }
                  indicatorCubit.setLedIndicatorData(ledIndicatorState!);
                }
              }, () => SmartDialog.dismiss(tag: 'ledIndicatorSelect'));
            },
            tag: 'ledIndicatorSelect');
      },
      child: SizedBox(
        width: 40.w,
        height: 40.h,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  width: 32.w,
                  height: 32.h,
                  'assets/color_check_white.png',
                  color: color.toColor(),
                  fit: BoxFit.fill,
                )),
          ],
        ),
      ),
    );
  }
}
