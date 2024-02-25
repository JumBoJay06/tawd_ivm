import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/src/data/fw_info.dart';
import 'package:tawd_ivm/src/util/dialog_widget_util.dart';

import '../../../bloc/firmware_update/firmware_update_cubit.dart';
import '../../../bloc/firmware_update/firmware_update_info_cubit.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/separator_view.dart';

class FirmwareUpdatePage extends StatefulWidget {
  const FirmwareUpdatePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return FirmwareUpdate();
  }
}

class FirmwareUpdate extends State<FirmwareUpdatePage> {
  FirmwareUpdateCubit firmwareUpdateCubit = FirmwareUpdateCubit();
  FirmwareUpdateInfoCubit firmwareUpdateInfoCubit = FirmwareUpdateInfoCubit();

  @override
  void initState() {
    super.initState();
    firmwareUpdateInfoCubit.getFwInfo();
  }

  @override
  void dispose() {
    firmwareUpdateInfoCubit.close();
    firmwareUpdateCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: firmwareUpdateCubit,
      listener: (context, state) {
        SmartDialog.dismiss(status: SmartStatus.allDialog);
        if (state is OnLoading) {
          DialogLoading.showLoading('loading',
              content: 'Updating firmware ...');
        }
        if (state is OnSuccess) {
          SmartDialog.show(
              builder: (context) {
                return DialogWidgetUtil.firmwareUpdateSuccessDialog(context);
              },
              tag: 'firmwareUpdateSuccessDialog');
          Future.delayed(const Duration(seconds: 2), () {
            SmartDialog.dismiss(tag: 'firmwareUpdateSuccessDialog');
            firmwareUpdateInfoCubit.getFwInfo();
          });
        }
        if (state is OnFail) {
          SmartDialog.show(
              builder: (context) {
                return DialogWidgetUtil.firmwareUpdateFailDialog(context);
              },
              tag: 'firmwareUpdateFailDialog');
          Future.delayed(const Duration(seconds: 2), () {
            SmartDialog.dismiss(tag: 'firmwareUpdateFailDialog');
          });
        }
      },
      child: Stack(
        children: [
          _createTitleWidget(context),
          BlocBuilder(
              bloc: firmwareUpdateInfoCubit,
              builder: (context, state) {
                SmartDialog.dismiss(status: SmartStatus.allDialog);
                if (state is OnLoading) {
                  DialogLoading.showLoading('loading', content: 'loading');
                }
                if (state is OnGetFwInfo) {
                  return _createContentWidget(context, state.fwInfo);
                }
                return const SizedBox();
              })
        ],
      ),
    );
  }

  _createContentWidget(BuildContext context, FwInfo info) {
    return Positioned(
        top: 112.h,
        left: 16.w,
        right: 16.w,
        bottom: 0,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: 343.w,
                  height: 177.h,
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
                          top: 18.h,
                          left: 16.w,
                          child: Text('FW Info.',
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
                          top: 57.h,
                          bottom: 8.h,
                          left: 0,
                          right: 0,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _createDetailItemWidget(
                                    context,
                                    index == 0
                                        ? 'assets/icon_version.png'
                                        : 'assets/icon_updated_date.png',
                                    index == 0
                                        ? 'Firmware version'
                                        : 'Last updated date',
                                    index == 0
                                        ? info.fwVersion
                                        : info.lastUpdateDate);
                              })),
                    ],
                  ),
                )),
            Positioned(
                bottom: 65.h,
                left: 0,
                right: 0,
                child: info.isHasNewVersion
                    ? GestureDetector(
                        onTap: () {
                          SmartDialog.show(
                              builder: (context) {
                                return DialogWidgetUtil.firmwareUpdateDialog(
                                    context,
                                    firmwareUpdateInfoCubit.binVersionName, () {
                                  SmartDialog.dismiss(
                                      tag: 'firmwareUpdateDialog');
                                  firmwareUpdateCubit.startFwUpdate(
                                      firmwareUpdateInfoCubit.binData,
                                      firmwareUpdateInfoCubit.binVersionName);
                                }, () {
                                  SmartDialog.dismiss(
                                      tag: 'firmwareUpdateDialog');
                                });
                              },
                              tag: 'firmwareUpdateDialog');
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
                              'Update',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorTheme.fontColor),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox())
          ],
        ));
  }

  _createDetailItemWidget(
    BuildContext context,
    String iconAsset,
    String title,
    String content,
  ) {
    return SizedBox(
      width: 331.w,
      height: 56.h,
      child: Stack(
        children: [
          Positioned(
              top: 8.h,
              bottom: 8.h,
              left: 16.w,
              child: Image.asset(
                width: 40.w,
                height: 40.h,
                iconAsset,
                fit: BoxFit.fill,
              )),
          Positioned(
              top: 10.h,
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
              top: 30.h,
              left: 66.w,
              child: Text(content,
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.left)),
        ],
      ),
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
            child: Text('Firmware Update',
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
}
