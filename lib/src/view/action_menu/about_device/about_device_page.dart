import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/route.dart';
import 'package:tawd_ivm/src/bloc/about_device/ivm_about_device_cubit.dart';
import 'package:tawd_ivm/src/data/about_device_data.dart';
import 'package:tawd_ivm/src/util/dialog_loading.dart';
import 'package:tawd_ivm/src/util/dialog_widget_util.dart';
import 'package:tawd_ivm/src/util/separator_view.dart';

import '../../../../generated/l10n.dart';
import '../../../theme/style.dart';

class AboutDevicePage extends StatefulWidget {
  const AboutDevicePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutDevicePage();
  }
}

class _AboutDevicePage extends State<AboutDevicePage> {
  Logger get _logger => Logger("AboutDevicePage");

  int groupSelect = 0;
  final GlobalKey productInfoKey = GlobalKey();
  final GlobalKey valveInfoKey = GlobalKey();
  final GlobalKey ledIndicatorKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  IvmAboutDeviceCubit aboutDeviceCubit = IvmAboutDeviceCubit();

  @override
  Widget build(BuildContext context) {
    return BlocListener<IvmAboutDeviceCubit, IvmAboutDeviceState>(
      bloc: aboutDeviceCubit,
      listener: (context, state) {
        if (state is Success) {
          SmartDialog.show(builder: (context) {
            return DialogWidgetUtil.aboutDeviceRefreshedDialog(context);
          }, tag: 'success');
          Future.delayed(const Duration(seconds: 3), () {
            SmartDialog.dismiss(tag: 'success');
          });
        }
        if (state is Fail) {
          SmartDialog.show(builder: (context) {
            return DialogWidgetUtil.aboutDeviceRefreshFailDialog(context);
          }, tag: 'fail');
          Future.delayed(const Duration(seconds: 3), () {
            SmartDialog.dismiss(tag: 'fail');
          });
        }
      }, child: Stack(
      children: [
        _createTitleWidget(context),
        _createInfoWidget(context),
        _createTabWidget(context),
        _createBottomMask()
      ],
    ),);
  }

  @override
  void dispose() {
    aboutDeviceCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(() {
      var currentOffset = scrollController.offset;
      setState(() {
        if (currentOffset >= 0 && currentOffset < 306.h) {
          groupSelect = 0;
        } else if (currentOffset >= 306.h && currentOffset < 687.h) {
          groupSelect = 1;
        } else {
          groupSelect = 2;
        }
      });
    });
    aboutDeviceCubit.loadAboutDeviceData(context);
    super.initState();
  }

  _createBottomMask() {
    return Positioned(
        bottom: 0,
        child: Container(
            width: 375.w,
            height: 120.h,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(0.4375917911529541, 0.6623137593269348),
                    end: Alignment(0.4371386766433716, 0),
                    colors: [
                      ColorTheme.background,
                      ColorTheme.backgroundTransparent
                    ]))));
  }

  _createInfoWidget(BuildContext context) {
    return BlocBuilder(
        bloc: aboutDeviceCubit,
        builder: (context, state) {
          if (state is Loading) {
            DialogLoading.showLoading('loading', content: 'loading');
            return Container();
          } else if (state is Success) {
            DialogLoading.dismissLoading('loading');
            return Positioned(
                left: 16.w,
                right: 16.w,
                top: 184.h,
                bottom: 0,
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: SizedBox(
                        width: 343.w,
                        height: 1315.h,
                        child: Stack(
                          children: [
                            Positioned(
                                key: productInfoKey,
                                top: 0,
                                child: Container(
                                  width: 343.w,
                                  height: 290.h,
                                  decoration: BoxDecoration(
                                      borderRadius: groupSelect == 0
                                          ? BorderRadius.vertical(
                                          bottom: Radius.circular(30.h))
                                          : BorderRadius.all(
                                          Radius.circular(30.h)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: ColorTheme.secondaryAlpha_10,
                                            offset: Offset(0, 10),
                                            blurRadius: 30,
                                            spreadRadius: 0)
                                      ],
                                      color: ColorTheme.white),
                                  child: _createProductInfoWidget(
                                      context, state.data[0]),
                                )),
                            Positioned(
                                key: valveInfoKey,
                                top: 306.h,
                                child: Container(
                                  width: 343.w,
                                  height: 365.h,
                                  decoration: BoxDecoration(
                                      borderRadius: groupSelect == 1
                                          ? BorderRadius.vertical(
                                          bottom: Radius.circular(30.h))
                                          : BorderRadius.all(
                                          Radius.circular(30.h)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: ColorTheme.secondaryAlpha_10,
                                            offset: Offset(0, 10),
                                            blurRadius: 30,
                                            spreadRadius: 0)
                                      ],
                                      color: ColorTheme.white),
                                  child: _createValveInfoWidget(
                                      context, state.data[1]),
                                )),
                            Positioned(
                                key: ledIndicatorKey,
                                top: 687.h,
                                child: Container(
                                  width: 343.w,
                                  height: 513.h,
                                  decoration: BoxDecoration(
                                      borderRadius: groupSelect == 2
                                          ? BorderRadius.vertical(
                                          bottom: Radius.circular(30.h))
                                          : BorderRadius.all(
                                          Radius.circular(30.h)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: ColorTheme.secondaryAlpha_10,
                                            offset: Offset(0, 10),
                                            blurRadius: 30,
                                            spreadRadius: 0)
                                      ],
                                      color: ColorTheme.white),
                                  child: _createLedIndicatorWidget(
                                      context, state.data[2]),
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ));
          } else {
            // todo error
            DialogLoading.dismissLoading('loading');
            return Container();
          }
        });
  }

  _createProductInfoWidget(BuildContext context, AboutDeviceData data) {
    return Stack(
      children: [
        Positioned(
            top: 18.h,
            left: 16.w,
            child: Text(S
                .of(context)
                .about_device_product_info,
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
            top: 8.h,
            bottom: 8.h,
            left: 0,
            right: 0,
            child: ListView.builder(
                itemCount: data.items.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = data.items[index];
                  return _createDetailItemWidget(context,
                      title: item.title,
                      content: item.content,
                      iconAsset: item.iconAsset,
                      isNoBallValveId: item.isShowError);
                }))
      ],
    );
  }

  _createValveInfoWidget(BuildContext context, AboutDeviceData data) {
    return Stack(
      children: [
        Positioned(
            top: 18.h,
            left: 16.w,
            child: Text(S
                .of(context)
                .about_device_info,
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
            top: 8.h,
            bottom: 8.h,
            left: 0,
            right: 0,
            child: ListView.builder(
                itemCount: data.items.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = data.items[index];
                  return _createDetailItemWidget(context,
                      title: item.title,
                      content: item.content,
                      iconAsset: item.iconAsset);
                }))
      ],
    );
  }

  _createLedIndicatorWidget(BuildContext context, AboutDeviceData data) {
    return Stack(
      children: [
        Positioned(
            top: 18.h,
            left: 16.w,
            child: Text(S
                .of(context)
                .device_settings_led_indicator,
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
            top: 8.h,
            bottom: 8.h,
            left: 0,
            right: 0,
            child: ListView.builder(
                itemCount: data.items.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = data.items[index];
                  return _createDetailItemWidget(context,
                      title: item.title,
                      content: item.content,
                      backgroundColor: item.ledIndicatorColor);
                }))
      ],
    );
  }

  _createDetailItemWidget(BuildContext context,
      {String iconAsset = 'assets/icon_light_white.png',
        Color backgroundColor = ColorTheme.white,
        String title = '',
        String content = '',
        bool isNoBallValveId = false}) {
    return GestureDetector(
      onTap: () {
        // 沒有 ball valve id 才會有點擊功能，其他的沒有
        // 之後有的話，把isNoBallValveId改成enum，並新增其他狀態
        if (isNoBallValveId) {
          Navigator.pushNamed(context, kRouteReplaceBallValvePage).then((
              value) => aboutDeviceCubit.loadAboutDeviceData(context));
        }
      },
      child: SizedBox(
        width: 331.w,
        height: 56.h,
        child: Stack(
          children: [
            Positioned(
                top: 8.h,
                bottom: 8.h,
                left: 16.w,
                child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.h)),
                        color: backgroundColor),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              width: 40.w,
                              height: 40.h,
                              iconAsset,
                              fit: BoxFit.fill,
                            )),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: isNoBallValveId
                                ? Image.asset(
                              width: 16.w,
                              height: 16.h,
                              'assets/icon_info_right.png',
                              fit: BoxFit.fill,
                            )
                                : const SizedBox())
                      ],
                    ))),
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
      ),
    );
  }

  _createTabWidget(BuildContext context) {
    return Positioned(
        top: 112.h,
        left: 16.w,
        right: 16.w,
        bottom: 628.h,
        child: Stack(
          children: [
            Container(
                width: 343.w,
                height: 72.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.h),
                        topRight: Radius.circular(30.h)),
                    boxShadow: const [
                      BoxShadow(
                          color: ColorTheme.secondaryAlpha_15,
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          spreadRadius: 0)
                    ],
                    color: ColorTheme.white)),
            Positioned(
              top: 0,
              bottom: 0,
              left: 16.w,
              child: InkWell(
                onTap: () {
                  setState(() {
                    groupSelect = 0;
                    _gotoAnchorPoint();
                  });
                },
                child: Row(
                  children: [
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: ColorTheme.secondary,
                      groupValue: groupSelect,
                      onChanged: (value) {},
                      value: 0,
                    ),
                    Text(S
                        .of(context)
                        .about_device_product_info,
                        style: TextStyle(
                            color: groupSelect == 0
                                ? ColorTheme.secondary
                                : ColorTheme.primaryAlpha_35,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProDisplay",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0.sp),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                left: 120.w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      groupSelect = 1;
                      _gotoAnchorPoint();
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: ColorTheme.secondary,
                        groupValue: groupSelect,
                        onChanged: (value) {},
                        value: 1,
                      ),
                      Text(S
                          .of(context)
                          .about_device_info,
                          style: TextStyle(
                              color: groupSelect == 1
                                  ? ColorTheme.secondary
                                  : ColorTheme.primaryAlpha_35,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SFProDisplay",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0.sp),
                          textAlign: TextAlign.left)
                    ],
                  ),
                )),
            Positioned(
                top: 0,
                bottom: 0,
                left: 223.w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      groupSelect = 2;
                      _gotoAnchorPoint();
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: ColorTheme.secondary,
                        groupValue: groupSelect,
                        onChanged: (value) {},
                        value: 2,
                      ),
                      Text(S
                          .of(context)
                          .device_settings_led_indicator,
                          style: TextStyle(
                              color: groupSelect == 2
                                  ? ColorTheme.secondary
                                  : ColorTheme.primaryAlpha_35,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SFProDisplay",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0.sp),
                          textAlign: TextAlign.left)
                    ],
                  ),
                )),
          ],
        ));
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
              'assets/light_6.png',
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
            child: Text(S.of(context).about_device,
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
                aboutDeviceCubit.loadAboutDeviceData(context);
              },
              child: Image.asset(
                'assets/light_15.png',
                width: 24.w,
                height: 24.h,
              ),
            ))
      ],
    );
  }

  void _gotoAnchorPoint() async {
    double offset;
    switch (groupSelect) {
      case 0:
        offset = 0;
        break;
      case 1:
        offset = 306.h;
        break;
      case 2:
        offset = 687.h;
        break;
      default:
        offset = 0;
        break;
    }
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    });
  }
}
