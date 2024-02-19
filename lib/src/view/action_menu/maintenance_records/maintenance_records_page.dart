import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logging/logging.dart';

import '../../../../generated/l10n.dart';
import '../../../bloc/maintenance_records/ivm_maintenance_records_cubit.dart';
import '../../../data/Maintenance_records_data.dart';
import '../../../data/about_device_data.dart';
import '../../../manager/data/pairing_data.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/separator_view.dart';

class MaintenanceRecordsPage extends StatefulWidget {
  const MaintenanceRecordsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _maintenanceRecords();
  }
}

class _maintenanceRecords extends State<MaintenanceRecordsPage> {
  Logger get _logger => Logger("MaintenanceRecordsPage");

  IvmMaintenanceRecordsCubit ivmMaintenanceRecordsCubit = IvmMaintenanceRecordsCubit();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_createTitleWidget(context), _createContentWidget(context)],
    );
  }

  @override
  void initState() {
    ivmMaintenanceRecordsCubit.loadMaintenanceRecords(context);
    super.initState();
  }

  @override
  void dispose() {
    ivmMaintenanceRecordsCubit.close();
    super.dispose();
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
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/light_6.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.fill,
              ),
            )),
        Positioned(
            top: 64.h,
            left: 0,
            right: 0,
            child: Text('Maintenance Records',
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
                // todo 履歷頁
              },
              child: Image.asset(
                'assets/light_17.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.fill,
              ),
            ))
      ],
    );
  }

  _createContentWidget(BuildContext context) {
    return BlocBuilder(
      bloc: ivmMaintenanceRecordsCubit,
        builder: (context, state) {
        if (state is Loading) {
          DialogLoading.showLoading('loading', content: 'loading');
          return Container();
        } else if (state is Success) {
          DialogLoading.dismissLoading('loading');
          final data = state.data;
          return Positioned(
              top: 112.h,
              left: 16.w,
              right: 16.w,
              bottom: 0,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: SizedBox(
                      width: 343.w,
                      height: 1056.h,
                      child: Stack(
                        children: [
                          Positioned(top: 0, child: _createIvmInfo(context, data.ivmInfo)),
                          Positioned(top: 249.h, child: _createCurrentValve(context, data.currentValve)),
                          Positioned(
                              top: 498.h, child: _createHistoricalValve(context, data.pairingLogList))
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

  _createIvmInfo(BuildContext context, List<Item> items) {
    return Container(
      width: 343.w,
      height: 233.h,
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
              child: Text('IVM info.',
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
                  itemCount: items.length,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return _createDetailItemWidget(
                        context,
                        title: item.title,
                        content: item.content,
                        iconAsset: item.iconAsset
                    );
                  }),)
        ],
      ),
    );
  }

  _createCurrentValve(BuildContext context, List<Item> items) {
    return Container(
      width: 343.w,
      height: 233.h,
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
              child: Text('Current valve',
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
                  itemCount: items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return _createDetailItemWidget(
                      context,
                      title: item.title,
                      content: item.content,
                      iconAsset: item.iconAsset
                    );
                  }))
        ],
      ),
    );
  }

  _createHistoricalValve(BuildContext context, List<PairingLog> items) {
    return Container(
      width: 343.w,
      height: 510.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: ColorTheme.white),
      child: Stack(
        children: [
          Positioned(
              top: 18.h,
              left: 16.w,
              child: Text('Historical valve.',
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
              child: SizedBox(
                width: 343.w,
                height: 60.h,
                child: Stack(
                  children: [
                    Container(
                        width: 343.w,
                        height: 60.h,
                        decoration: const BoxDecoration(
                            color: ColorTheme.secondaryAlpha_15)),
                    Positioned(
                        top: 7.h,
                        left: 41.w,
                        child: Image.asset(
                          'assets/icon_ball_32.png',
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.fill,
                        )),
                    Positioned(
                        top: 39.h,
                        left: 24.w,
                        child: Text("Ball Valve ID",
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w400,
                                fontFamily: "SFProDisplay",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0.sp),
                            textAlign: TextAlign.center)),
                    Positioned(
                        top: 7.h,
                        left: 155.w,
                        child: Image.asset(
                          'assets/icon_date_bel_32.png',
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.fill,
                        )),
                    Positioned(
                        top: 39.h,
                        left: 139.w,
                        child: Text("Pairing date",
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w400,
                                fontFamily: "SFProDisplay",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0.sp),
                            textAlign: TextAlign.center)),
                    Positioned(
                        top: 7.h,
                        left: 270.w,
                        child: Image.asset(
                          'assets/icon_ball_time_32.png',
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.fill,
                        )),
                    Positioned(
                        top: 39.h,
                        left: 248.w,
                        child: Text("Cycle counter",
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w400,
                                fontFamily: "SFProDisplay",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0.sp),
                            textAlign: TextAlign.center)),
                  ],
                ),
              )),
          Positioned(
              top: 110.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    PairingLog item;
                    _logger.info("${items.length} < $index");
                    if (items.length > index) {
                      item = items[index];
                    } else {
                      item = PairingLog('--', '--', 0);
                    }

                    return SizedBox(
                      width: 343.w,
                      height: 40.h,
                      child: Stack(
                        children: [
                          Positioned(
                              child: Container(
                              width: 343.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: (index%2 == 1) ? ColorTheme.primaryAlpha_10 : ColorTheme.white
                              )
                          )),
                          Positioned(
                              top: 13.h,
                              bottom: 11.h,
                              left: 15.w,
                              child: Text(item.ivmId,
                                  style: TextStyle(
                                      color: ColorTheme.primaryAlpha_50,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SFProDisplay",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0.sp),
                                  textAlign: TextAlign.left)),
                          Positioned(
                              top: 13.h,
                              bottom: 11.h,
                              left: 136.w,
                              child: Text(item.date,
                                  style: TextStyle(
                                      color: ColorTheme.primaryAlpha_50,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SFProDisplay",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0.sp),
                                  textAlign: TextAlign.left)),
                          Positioned(
                              top: 13.h,
                              bottom: 11.h,
                              left: 267.w,
                              child: Text("${item.totalUsed} time(s)",
                                  style: TextStyle(
                                      color: ColorTheme.primaryAlpha_50,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "SFProDisplay",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0.sp),
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  _createDetailItemWidget(
    BuildContext context, {
    String iconAsset = 'assets/icon_light_white.png',
    String title = '',
    String content = '',
  }) {
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
}
