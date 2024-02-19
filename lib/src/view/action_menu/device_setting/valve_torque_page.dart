import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/data/enum_util.dart';
import 'package:tawd_ivm/src/data/valve_torque.dart';

import '../../../bloc/device_setting/ivm_valve_torque_cubit.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/dialog_widget_util.dart';
import '../../../util/separator_view.dart';

// todo 設定上下限與實作bloc

class ValveTorquePage extends StatefulWidget {
  const ValveTorquePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _valveTorque();
  }
}

class _valveTorque extends State<ValveTorquePage> {
  Logger get _logger => Logger("ValveTorquePage");
  var selectIndex = 0;
  var isChangeUnit = false;
  var isUpdateData = false;
  final minControl = TextEditingController(text: '0');
  final maxControl = TextEditingController(text: '0');
  final IvmValveTorqueCubit ivmValveTorqueCubit = IvmValveTorqueCubit();

  @override
  void initState() {
    ivmValveTorqueCubit.loadValveTorqueData();
    super.initState();
  }

  @override
  void dispose() {
    ivmValveTorqueCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IvmValveTorqueCubit, IvmValveTorqueState>(
        bloc: ivmValveTorqueCubit,
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
            _logger.info("${state.data.unit}");
            maxControl.text = state.data.max.toString();
            minControl.text = state.data.min.toString();
            if (!isChangeUnit) {
              selectIndex = state.data.unit.id;
            }
            return Stack(
              children: [
                _createTitleWidget(context),
                _createUnitSelectWidget(context),
                _createAlertValueSettingWidget(context),
                _createSaveButton(context)
              ],
            );
          } else {
            // todo error
            if (state is Fail) {
              _logger.shout('${state.e}');
            }
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
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/light_3.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.fill,
              ),
            )),
        Positioned(
            top: 64.h,
            left: 0,
            right: 0,
            child: const Text('Valve Torque',
                style: TextStyle(
                    color: ColorTheme.fontColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center)),
      ],
    );
  }

  _createUnitSelectWidget(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 112.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              width: 343.w,
              height: 163.h,
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
                      child: const Text('Unit',
                          style: TextStyle(
                              color: ColorTheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SFProDisplay",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
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
                      top: 105.h,
                      left: 16.w,
                      right: 16.w,
                      child: Container(
                          width: 311.w,
                          height: 1.h,
                          decoration: const BoxDecoration(
                              color: ColorTheme.primaryAlpha_10))),
                  Positioned(
                      top: 49.h,
                      left: 16.w,
                      right: 16.w,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isChangeUnit = true;
                            selectIndex = 0;
                          });
                        },
                        child:
                            _createUnitWidget(context, 'Nm', selectIndex == 0),
                      )),
                  Positioned(
                      top: 106.h,
                      left: 16.w,
                      right: 16.w,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isChangeUnit = true;
                            selectIndex = 1;
                          });
                        },
                        child: _createUnitWidget(
                            context, 'kgf*cm', selectIndex == 1),
                      )),
                ],
              ),
            ))
      ],
    );
  }

  _createUnitWidget(BuildContext context, String title, bool isSelected) {
    return SizedBox(
      width: 311.w,
      height: 56.h,
      child: Stack(
        children: [
          Positioned(
              top: 19.h,
              left: 8.w,
              child: Text(title,
                  style: const TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                  textAlign: TextAlign.left)),
          _createCheckWidget(isSelected),
        ],
      ),
    );
  }

  _createCheckWidget(bool isSelected) {
    if (isSelected) {
      return Positioned(
          right: 8.w,
          top: 20.h,
          bottom: 20.h,
          child: Image.asset(
            'assets/icon_check.png',
            width: 24.w,
            height: 24.h,
          ));
    } else {
      return Positioned(
          right: 8.w,
          top: 20.h,
          bottom: 20.h,
          child: SizedBox(
            width: 24.w,
            height: 24.h,
          ));
    }
  }

  _createAlertValueSettingWidget(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 291.h,
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
                      child: const Text('Alert value',
                          style: TextStyle(
                              color: ColorTheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SFProDisplay",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
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
                      child: const Text(
                          "Once the value of torque is below or above the set value, the LED indicator will show abnormal light.",
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_50,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left)),
                  Positioned(
                      top: 132.h,
                      left: 16.w,
                      right: 16.w,
                      child: TextField(
                        controller: minControl,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelText: 'Min. value',
                            labelStyle: TextStyle(
                                color: ColorTheme.primaryAlpha_35,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            filled: true,
                            fillColor: ColorTheme.primaryAlpha_10),
                      )),
                  Positioned(
                      top: 192.h,
                      right: 24.w,
                      child: const Text("Factory default: 100",
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_35,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.right)),
                  Positioned(
                      top: 214.h,
                      left: 16.w,
                      right: 16.w,
                      child: TextField(
                        controller: maxControl,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelText: 'Max. value',
                            labelStyle: TextStyle(
                                color: ColorTheme.primaryAlpha_35,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.primary),
                            ),
                            filled: true,
                            fillColor: ColorTheme.primaryAlpha_10),
                      )),
                  Positioned(
                      top: 274.h,
                      right: 24.w,
                      child: const Text("Factory default: 400",
                          style: TextStyle(
                              color: ColorTheme.primaryAlpha_35,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Helvetica",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
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
                isChangeUnit = false;
                isUpdateData = true;
                ivmValveTorqueCubit.setValveTorqueData(ValveTorque(
                    TorqueUnit.fromInt(selectIndex),
                    int.parse(maxControl.text),
                    int.parse(minControl.text)));
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
                child: const Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 20,
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
