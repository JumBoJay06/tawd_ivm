import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/route.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_connection_bloc.dart';
import 'package:tawd_ivm/src/bloc/paired_device/paired_device_bloc.dart';
import 'package:tawd_ivm/src/manager/data/led_indicator_state.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/theme/style.dart';
import 'package:tawd_ivm/src/util/dialog_widget_util.dart';

import '../../../generated/l10n.dart';
import '../../bloc/action_menu/ivm_action_menu_cubit.dart';
import '../../bloc/action_menu/ivm_connection_cubit.dart';
import '../../bloc/ivm/manager/ivm_check_temperature_cubit.dart';
import '../../util/dialog_loading.dart';

class ActionMenu extends StatefulWidget {
  const ActionMenu({super.key});

  @override
  State<ActionMenu> createState() => _ActionMenuState();
}

class _ActionMenuState extends State<ActionMenu> {
  IvmActionMenuCubit ivmActionMenuCubit = IvmActionMenuCubit();
  IvmConnectionCubit ivmConnectionCubit = IvmConnectionCubit();
  IvmCheckTemperatureCubit checkTemperature = IvmCheckTemperatureCubit();
  IvmConnectionBloc ivmConnectionBloc = IvmConnectionBloc();

  Logger get _logger => Logger("ActionMenu");
  bool isConnecting = false;

  bool isDeviceInfoClicked = false;
  bool isAutoTestClicked = false;
  bool isMaintenanceClicked = false;
  bool isRecordChartClicked = false;
  bool isTraceabilityClicked = false;
  bool isDeviceSettingClicked = false;
  bool isFwUpdateClicked = false;

  @override
  void initState() {
    super.initState();
    ivmActionMenuCubit.loadActionMenuData();
    checkTemperature.getTemperature();
    ivmConnectionCubit.observeIvmConnectState();
  }

  @override
  void dispose() {
    ivmActionMenuCubit.close();
    checkTemperature.close();
    ivmConnectionCubit.close();
    ivmConnectionBloc.add(IvmDisconnect());
    ivmConnectionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentDeviceName = IvmManager.getInstance().getCurrentDeviceName();
    if (currentDeviceName != null && currentDeviceName.isNotEmpty) {
      context
          .read<PairedDeviceBloc>()
          .add(GetPairedDeviceByName(currentDeviceName));
    }
    return MultiBlocListener(
      listeners: [
        BlocListener(
            bloc: checkTemperature,
            listener: (context, state) {
              if (state is IvmCmdResult) {
                if (state.isTooHigh) {
                  SmartDialog.show(
                      builder: (context) {
                        return DialogWidgetUtil.temperatureAbnormal(
                            context,
                            currentDeviceName ?? 'test',
                            () => {
                                  SmartDialog.dismiss(tag: 'Check_Temperature')
                                });
                      },
                      tag: 'Check_Temperature');
                }
              }
            }),
        BlocListener(
            bloc: ivmConnectionCubit,
            listener: (context, state) {
              if (state is Connected) {
                DialogLoading.dismissLoading('connecting');
                _logger.info('reconnect success');
                if (isConnecting) {
                  isConnecting = false;
                  SmartDialog.show(
                      builder: (context) {
                        return DialogWidgetUtil.ivmConnectedDialog(context);
                      },
                      tag: 'connected',
                      clickMaskDismiss: false,
                      backDismiss: false,
                      keepSingle: true);
                  Future.delayed(const Duration(seconds: 2), () {
                    SmartDialog.dismiss(tag: 'connected');
                  });
                }
              } else if (state is Connecting) {
                DialogLoading.showLoading('connecting',
                    content: "IVM Reconnecting...");
                _logger.info('reconnecting');
                isConnecting = true;
              } else if (state is Disconnected) {
                DialogLoading.dismissLoading('connecting');
                _logger.info('connecting');
                if (isConnecting) {
                  isConnecting = false;
                  SmartDialog.show(
                      builder: (context) {
                        return DialogWidgetUtil.ivmDisconnected(context, () {
                          SmartDialog.dismiss(tag: 'disconnected');
                          Navigator.pushNamedAndRemoveUntil(this.context,
                              kRouteSelectLanguage, (route) => false);
                        });
                      },
                      tag: "disconnected",
                      clickMaskDismiss: false,
                      backDismiss: false,
                      keepSingle: true);
                }
              } else if (state is BleOff) {
                _logger.info('ble off');
                _openBleOffDialog();
              }
            })
      ],
      child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, kRouteScanStartPage, (route) => false);
          },
          child: Stack(
            children: [
              Container(
                width: 375.w,
                height: 812.h,
                color: ColorTheme.background,
              ),
              BlocBuilder(
                  bloc: ivmActionMenuCubit,
                  builder: (context, state) {
                    if (state is Loading) {
                      DialogLoading.showLoading('loading', content: 'loading');
                      return _createHeaderWidget(context, '--', '--');
                    } else if (state is Success) {
                      DialogLoading.dismissLoading('loading');
                      return _createHeaderWidget(
                          context, state.name, state.location);
                    } else {
                      // todo error
                      DialogLoading.dismissLoading('loading');
                      return _createHeaderWidget(context, '--', '--');
                    }
                  }),
              _createMenuWidget(context),
            ],
          )),
    );
  }

  Widget _createHeaderWidget(
      BuildContext context, String name, String location) {
    return Stack(
      children: [
        Image.asset(
          'assets/header_bg_3.png',
          width: 375.w,
          height: 280.h,
          fit: BoxFit.fill,
        ),
        Positioned(
            top: 58.h,
            left: 16.w,
            child: Image.asset(
              "assets/light_3.png",
              width: 24.w,
              height: 24.h,
            )),
        Positioned(
            top: 42.h,
            left: 0.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, kRouteScanStartPage, (route) => false);
              },
              child: SizedBox(
                width: 56.w,
                height: 56.h,
              ),
            )),
        Positioned(
            top: 120.h,
            left: 24.w,
            right: 24.w,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(name,
                  maxLines: 1,
                  style: TextStyle(
                      color: ColorTheme.fontColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Helvetica",
                      fontStyle: FontStyle.normal,
                      fontSize: 40.0.sp),
                  textAlign: TextAlign.left),
            )),
        Positioned(
            top: 165.h,
            left: 24.w,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(location,
                  maxLines: 1,
                  style: TextStyle(
                      color: ColorTheme.fontColorSecondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Helvetica",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.left),
            )),
      ],
    );
  }

  Widget _createMenuWidget(BuildContext context) {
    return Positioned(
        top: 200.h,
        left: 16.w,
        right: 16.w,
        child: Container(
          width: 343.w,
          height: 564.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: ColorTheme.secondaryAlpha_10,
                  offset: Offset(0, 10),
                  blurRadius: 30,
                  spreadRadius: 0)
            ],
            color: ColorTheme.white,
          ),
          child: Stack(
            children: [
              _createAboutDeviceWidget(context),
              _createAutomatedTestingWidget(context),
              _createMaintenanceRecordsWidget(context),
              _createRecordChartWidget(context),
              _createTraceabilityWidget(context),
              _createDeviceSettingsWidget(context),
              _createFirmwareUpdateWidget(context),
              _createDividerWidget()
            ],
          ),
        ));
  }

  _createAboutDeviceWidget(BuildContext context) {
    return Positioned(
        top: 0,
        left: 16.w,
        child: GestureDetector(
          onTap: () async {
            if (isDeviceInfoClicked) {
              return;
            }
            setState(() {
              isDeviceInfoClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isDeviceInfoClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteAboutDevicePage);
            });
          },
          child: SizedBox(
            width: 155.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    child: isDeviceInfoClicked
                        ? Container(
                            width: 155.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      isDeviceInfoClicked
                          ? 'assets/icon_about_focus.png'
                          : 'assets/icon_about.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 16.h,
                    right: 16.h,
                    bottom: 5.h,
                    child: Text(S.of(context).about_device,
                        style: TextStyle(
                            height: 1.0.h,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createAutomatedTestingWidget(BuildContext context) {
    return Positioned(
        top: 0,
        right: 16.w,
        child: GestureDetector(
          onTap: () async {
            if (isAutoTestClicked) {
              return;
            }
            setState(() {
              isAutoTestClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isAutoTestClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteAutomatedTestingPage);
            });
          },
          child: SizedBox(
            width: 150.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    child: isAutoTestClicked
                        ? Container(
                            width: 150.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      isAutoTestClicked
                          ? 'assets/icon_test_focus.png'
                          : 'assets/icon_test.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 16.h,
                    right: 16.h,
                    bottom: 5.h,
                    child: Text(S.of(context).auto_test,
                        style: TextStyle(
                            height: 1.0.h,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createMaintenanceRecordsWidget(BuildContext context) {
    return Positioned(
        top: 140.h,
        left: 16.w,
        child: GestureDetector(
          onTap: () async {
            if (isMaintenanceClicked) {
              return;
            }
            setState(() {
              isMaintenanceClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isMaintenanceClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteMaintenanceRecordsPage);
            });
          },
          child: SizedBox(
            width: 150.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    child: isMaintenanceClicked
                        ? Container(
                            width: 155.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      isMaintenanceClicked
                          ? 'assets/icon_record_focus.png'
                          : 'assets/icon_record.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 16.h,
                    right: 16.h,
                    bottom: 5.h,
                    child: Text(S.of(context).maintenance_records,
                        style: TextStyle(
                            height: 1.0.h,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createRecordChartWidget(BuildContext context) {
    return Positioned(
        top: 140.h,
        right: 16.w,
        child: GestureDetector(
          onTap: () async {
            if (isRecordChartClicked) {
              return;
            }
            setState(() {
              isRecordChartClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isRecordChartClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteRecordChartPage);
            });
          },
          child: SizedBox(
            width: 150.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    child: isRecordChartClicked
                        ? Container(
                            width: 155.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      isRecordChartClicked
                          ? 'assets/icon_chart_focus.png'
                          : 'assets/icon_chart.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 16.h,
                    right: 16.h,
                    bottom: 5.h,
                    child: Text(S.of(context).record_chart_,
                        style: TextStyle(
                            height: 1.0.h,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createTraceabilityWidget(BuildContext context) {
    return Positioned(
        top: 281.h,
        left: 16.w,
        child: GestureDetector(
          onTap: () async {
            if (isTraceabilityClicked) {
              return;
            }
            setState(() {
              isTraceabilityClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isTraceabilityClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteTraceabilityPage);
            });
          },
          child: SizedBox(
            width: 150.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    child: isTraceabilityClicked
                        ? Container(
                            width: 155.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_traceability.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 16.h,
                    right: 16.h,
                    bottom: 5.h,
                    child: Text(S.of(context).traceability,
                        style: TextStyle(
                            height: 1.0.h,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createDeviceSettingsWidget(BuildContext context) {
    return Positioned(
        top: 281.h,
        right: 16.w,
        child: GestureDetector(
          onTap: () async {
            if (isDeviceSettingClicked) {
              return;
            }
            setState(() {
              isDeviceSettingClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isDeviceSettingClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteDeviceSettingPage)
                  .then((value) => ivmActionMenuCubit.loadActionMenuData());
            });
          },
          child: SizedBox(
            width: 150.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    child: isDeviceSettingClicked
                        ? Container(
                            width: 155.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_setting.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 16.h,
                    right: 16.h,
                    bottom: 5.h,
                    child: Text(S.of(context).device_settings_,
                        style: TextStyle(
                            height: 1.0.h,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createFirmwareUpdateWidget(BuildContext context) {
    return Positioned(
        top: 422.h,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () async {
            if (isFwUpdateClicked) {
              return;
            }
            setState(() {
              isFwUpdateClicked = true;
            });
            await Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                isFwUpdateClicked = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, kRouteFirmwareUpdatePage);
            });
          },
          child: SizedBox(
            width: 343.w,
            height: 141.h,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                    right: 0,
                    child: isFwUpdateClicked
                        ? Container(
                            width: 155.w,
                            height: 140.h,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(154)),
                                gradient: RadialGradient(radius: 0.6, colors: [
                                  ColorTheme.secondaryAlpha_35,
                                  ColorTheme.backgroundTransparent
                                ])))
                        : const SizedBox()),
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_update.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).fw_update,
                        style: TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ));
  }

  _createDividerWidget() {
    return Stack(
      children: [
        Positioned(
            top: 140.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 281.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 422.h,
            left: 16.w,
            right: 16.w,
            child: Container(
                width: 311.w,
                height: 1.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 10.h,
            left: 171.w,
            right: 171.w,
            child: Container(
                width: 1.w,
                height: 120.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 151.h,
            left: 171.w,
            right: 171.w,
            child: Container(
                width: 1.w,
                height: 120.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
        Positioned(
            top: 292.h,
            left: 171.w,
            right: 171.w,
            child: Container(
                width: 1.w,
                height: 120.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.primaryAlpha_10))),
      ],
    );
  }

  void _openBleOffDialog() {
    SmartDialog.show(
        tag: 'ble_off',
        builder: (context) {
          return DialogWidgetUtil.bleOffDialog(context, () {
            AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
            Navigator.pushNamedAndRemoveUntil(
                this.context, kRouteSelectLanguage, (route) => false);
            SmartDialog.dismiss(tag: 'ble_off');
          }, () {
            Navigator.pushNamedAndRemoveUntil(
                this.context, kRouteSelectLanguage, (route) => false);
            SmartDialog.dismiss(tag: 'ble_off');
          });
        });
  }
}
