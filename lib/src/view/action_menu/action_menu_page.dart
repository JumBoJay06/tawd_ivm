import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/route.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_connection_bloc.dart';
import 'package:tawd_ivm/src/bloc/paired_device/paired_device_bloc.dart';
import 'package:tawd_ivm/src/theme/style.dart';

import '../../../generated/l10n.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PairedDeviceBloc>().add(GetPairedDevice());
    return Stack(
      children: [
        Container(
          width: 375.w,
          height: 812.h,
          color: ColorTheme.background,
        ),
        _createHeaderWidget(context),
        _createMenuWidget(context),
      ],
    );
  }

  // todo device 資料(預期從DB來)
  Widget _createHeaderWidget(BuildContext context) {
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
            child: GestureDetector(
              onTap: () {
                context.read<IvmConnectionBloc>().add(IvmDisconnect());
                Navigator.pushNamedAndRemoveUntil(context, kRouteScanStartPage, (route) => false);
              },
              child: Image.asset(
                "assets/light_3.png",
                width: 24.w,
                height: 24.h,
              ),
            )),
        Positioned(
            top: 120.h,
            left: 24.w,
            child: const Text("Name",
                style: TextStyle(
                    color: ColorTheme.fontColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 40.0),
                textAlign: TextAlign.left)),
        Positioned(
            top: 160.h,
            left: 24.w,
            child: const Text("Location",
                style: TextStyle(
                    color: ColorTheme.fontColorSecondary,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Helvetica",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left)),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).about_device_product_info);
          },
          child: SizedBox(
            width: 171.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_ivm.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).about_device_product_info,
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).selt_test);
          },
          child: SizedBox(
            width: 171.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_test.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).selt_test,
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).operational_records);
          },
          child: SizedBox(
            width: 171.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_record.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).operational_records,
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).record_chart_);
          },
          child: SizedBox(
            width: 171.w,
            height: 140.h,
            child: Stack(
              children: [
                Positioned(
                    top: 24.h,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icon_chart.png',
                      width: 72.w,
                      height: 72.h,
                      fit: BoxFit.fitHeight,
                    )),
                Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).record_chart_,
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).traceability_);
          },
          child: SizedBox(
            width: 171.w,
            height: 140.h,
            child: Stack(
              children: [
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
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).traceability_,
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).device_settings_);
          },
          child: SizedBox(
            width: 171.w,
            height: 140.h,
            child: Stack(
              children: [
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
                    left: 0,
                    right: 0,
                    child: Text(S.of(context).device_settings_,
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
          onTap: () {
            SmartDialog.showToast(S.of(context).fw_update);
          },
          child: SizedBox(
            width: 343.w,
            height: 141.h,
            child: Stack(
              children: [
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
                        style: const TextStyle(
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
}
