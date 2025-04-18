import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../../../../generated/l10n.dart';
import '../../../bloc/record_chart/record_chart_cubit.dart';
import '../../../data/about_device_data.dart';
import '../../../data/shared_preferences/my_shared_preferences.dart';
import '../../../manager/data/history_log.dart';
import '../../../theme/style.dart';
import '../../../util/dialog_loading.dart';
import '../../../util/separator_view.dart';

class RecordChartPage extends StatefulWidget {
  const RecordChartPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _recordChart();
  }
}

class _recordChart extends State<RecordChartPage> {
  Logger get _logger => Logger("MaintenanceRecordsPage");
  int selectIndex = 0;
  RecordChartCubit recordChartCubit = RecordChartCubit();
  late String torqueUnit;
  late double torqueFormat;
  late int pressureUnitSetting;
  late String pressureUnit;
  late double pressureFormat;


  @override
  void initState() {
    super.initState();
    final MySharedPreferences prefs = MySharedPreferences.getInstance();
    final isTorqueUnitNm = prefs.getTorqueUnit().id == 0;
    torqueUnit = isTorqueUnitNm ? 'Nm' : 'kgf*cm';
    torqueFormat = isTorqueUnitNm ? 1 : 10.2;
    pressureUnitSetting = prefs.getPressureUnit().id;
    switch (pressureUnitSetting) {
      case 1:
        pressureUnit = 'bar';
        pressureFormat = 0.07;
        break;
      case 2:
        pressureUnit = 'kPa';
        pressureFormat = 7;
        break;
      default:
        pressureUnit = 'psi';
        pressureFormat = 1;
        break;
    }
    recordChartCubit.loadRecordChart(context);
  }

  @override
  void dispose() {
    recordChartCubit.close();
    super.dispose();
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
            bottom: 728.h,
            left: 56.w,
            right: 56.w,
            child: Text(S.of(context).record_chart_,
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
    return BlocBuilder(
        bloc: recordChartCubit,
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
                child: Stack(
                  children: [
                    Positioned(
                        top: 0, child: _createIvmInfo(context, data.ivmInfo)),
                    Positioned(
                        top: 249.h,
                        child: _createChartInfo(context, data.logs)),
                  ],
                ));
          } else {
            // todo error
            DialogLoading.dismissLoading('loading');
            return Container();
          }
        });
  }

  _createChartInfo(BuildContext context, List<HistoryLog> logs) {
    return Container(
      width: 343.w,
      height: 451.h,
      clipBehavior: Clip.hardEdge,
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
          _createTabWidget(context),
          _createChartDetail(context, logs)
        ],
      ),
    );
  }

  _createChartDetail(BuildContext context, List<HistoryLog> logs) {
    return Positioned(
        top: 62.h,
        left: 0,
        right: 0,
        bottom: 0,
        child: SizedBox(
          width: 343.w,
          height: 434.h,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    switch (index) {
                      case 0:
                        return _createChartWidget(context, logs);
                      case 1:
                        return _createChartItemsWidget(context,
                            logs..sort((a, b) => b.index.compareTo(a.index)));
                      default:
                        return Container();
                    }
                  },
                  childCount: 2,
                ),
              )
            ],
          ),
        ));
  }

  _createChartWidget(BuildContext context, List<HistoryLog> logs) {
    return SizedBox(
      width: 343.w,
      height: 272.h,
      child: Stack(
        children: [
          Positioned(
              top: 20.h,
              left: 10.5.w,
              right: 10.5.w,
              bottom: 24.5.h,
              child: LineChart(
                mainData(logs),
                duration: const Duration(milliseconds: 500),
              )),
          // Positioned(
          //     top: 20.h,
          //     left: 10.5.w,
          //     right: 10.5.w,
          //     bottom: 24.5.h,
          //     child: selectIndex == 3 ? LineChart(
          //       mainData2(logs),
          //       duration: const Duration(milliseconds: 500),
          //     ) : const SizedBox()),
          Positioned(
              top: 251.h,
              left: 124.w,
              child: Text(S.of(context).record_chart_last_300_records,
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Helvetica",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0.sp),
                  textAlign: TextAlign.right))
        ],
      ),
    );
  }

  _createChartItemsWidget(BuildContext context, List<HistoryLog> logs) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _createChartTitleItemWidget(context);
          } else {
            return _createChartItemWidget(context, index, logs[index - 1]);
          }
        });
  }

  _createChartItemWidget(BuildContext context, int index, HistoryLog log) {
    List<String> itemValue = getItemValue(index, log);
    return Container(
      width: 343.w,
      height: 40.h,
      decoration: BoxDecoration(
          color:
              (index % 2 == 1) ? ColorTheme.primary.withOpacity(0.025) : ColorTheme.white),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Positioned(
              top: 13.h,
              right: 303.w,
              child: Text((log.index).toString(),
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.left)),
          Positioned(
              top: 13.h,
              right: 140.w,
              child: Text(itemValue[0],
                  style: TextStyle(
                      color: ColorTheme.primaryAlpha_50,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.right)),
          Positioned(
              top: 13.h,
              right: 15.w,
              child: selectIndex != 3
                  ? const SizedBox()
                  : Text(itemValue[1],
                      style: TextStyle(
                          color: ColorTheme.primaryAlpha_50,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFProDisplay",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0.sp),
                      textAlign: TextAlign.right))
        ],
      ),
    );
  }

  List<String> getItemValue(int index, HistoryLog log) {
    List<String> result = List.empty(growable: true);
    switch (selectIndex) {
      case 0:
        result.add("${log.valveAngle}°");
        break;
      case 1:
        result.add("${(log.strainGauge * torqueFormat).toStringAsFixed(1)} $torqueUnit");
        break;
      case 2:
        result.add("${(log.pressure * pressureFormat).toStringAsFixed(1)} $pressureUnit");
        break;
      case 3:
        result.add("${(log.strainGauge * torqueFormat).toStringAsFixed(1)} $torqueUnit");
        result.add("${(log.pressure * pressureFormat).toStringAsFixed(1)} $pressureUnit");
        break;
    }

    return result;
  }

  _createChartTitleItemWidget(BuildContext context) {
    String title1 = '';
    String title2 = '';
    switch (selectIndex) {
      case 0:
        title1 = S.of(context).about_device_angle;
        break;
      case 1:
        title1 = S.of(context).about_device_torque;
        break;
      case 2:
        title1 = S.of(context).record_chart_emission;
        break;
      case 3:
        title1 = S.of(context).about_device_torque;
        title2 = S.of(context).record_chart_emission;
        break;
    }
    return SizedBox(
      width: 343.w,
      height: 49.h,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SeparatorView(
                height: 1.h,
                dashWidth: 5.w,
                color: ColorTheme.primaryAlpha_50,
              )),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: 343.w,
                height: 48.h,
                decoration:
                    const BoxDecoration(color: ColorTheme.secondaryAlpha_15),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Positioned(
                        top: 16.h,
                        right: 305.w,
                        child: Text("#",
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0.sp),
                            textAlign: TextAlign.left)),
                    Positioned(
                        top: 16.h,
                        right: 142.w,
                        child: Text(title1,
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Helvetica",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0.sp),
                            textAlign: TextAlign.left)),
                    Positioned(
                        top: 16.h,
                        right: 18.w,
                        child: selectIndex != 3
                            ? const SizedBox()
                            : Text(title2,
                                style: TextStyle(
                                    color: ColorTheme.primary,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Helvetica",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0.sp),
                                textAlign: TextAlign.left)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  _createTabWidget(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        child: SizedBox(
          width: 343.w,
          height: 62.h,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = 0;
                      });
                    },
                    child: _createTabItem(context, 'assets/icon_angle.png',
                        'assets/icon_angle_light_32.png', S.of(context).about_device_angle,
                        isSelected: selectIndex == 0),
                  )),
              Positioned(
                  top: 0,
                  left: 86.w,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = 1;
                      });
                    },
                    child: _createTabItem(context, 'assets/icon_torque.png',
                        'assets/icon_torque_light_32.png', S.of(context).about_device_torque,
                        isSelected: selectIndex == 1),
                  )),
              Positioned(
                  top: 0,
                  left: 172.w,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = 2;
                      });
                    },
                    child: _createTabItem(context, 'assets/icon_emission.png',
                        'assets/icon_emission_light_32.png', S.of(context).record_chart_emission,
                        isSelected: selectIndex == 2),
                  )),
              Positioned(
                  top: 0,
                  left: 258.w,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = 3;
                      });
                    },
                    child: _createTabItem(context, 'assets/icon_t_e.png',
                        'assets/icon_t_e_light_32.png', S.of(context).record_chart_t_e,
                        isSelected: selectIndex == 3),
                  )),
              Positioned(
                  top: 60.h,
                  left: 0,
                  right: 0,
                  child: Container(
                      width: 343.w,
                      height: 2.h,
                      decoration:
                          const BoxDecoration(color: ColorTheme.secondary)))
            ],
          ),
        ));
  }

  _createTabItem(BuildContext context, String iconAsset,
      String selectedIconAsset, String title,
      {bool isSelected = false}) {
    return Container(
      width: 86.w,
      height: 60.h,
      decoration: BoxDecoration(
          color: isSelected ? ColorTheme.secondary : ColorTheme.white),
      child: Stack(
        children: [
          Positioned(
              top: 6.h,
              left: 27.w,
              child: Image.asset(
                isSelected ? selectedIconAsset : iconAsset,
                width: 32.w,
                height: 32.h,
              )),
          Positioned(
              top: 38.h,
              left: 0,
              right: 0,
              child: Text(title,
                  style: TextStyle(
                      color: isSelected ? ColorTheme.white : ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0.sp),
                  textAlign: TextAlign.center))
        ],
      ),
    );
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
                padding: EdgeInsets.zero,
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return _createDetailItemWidget(context,
                        title: item.title,
                        content: item.content,
                        iconAsset: item.iconAsset);
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

  LineChartData mainData(List<HistoryLog> logs) {
    return LineChartData(
      clipData: const FlClipData.all(),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: ColorTheme.primaryAlpha_10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: ColorTheme.primary,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final TextStyle textStyle = TextStyle(
                color: ColorTheme.fontColor,
                fontWeight: FontWeight.w500,
                fontFamily: "Helvetica",
                fontStyle: FontStyle.normal,
                fontSize: 12.0.sp,
              );
              return LineTooltipItem(
                  touchedSpot.y.toStringAsFixed(1),
                  textStyle,
                  textAlign: TextAlign.center);
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      minX: getChartMinX(logs).toDouble(),
      maxX: getChartMaxX(logs).toDouble(),
      minY: getChartMinY(logs).toDouble(),
      maxY: getChartMaxY(logs).toDouble(),
      lineBarsData: getLineCharts(logs),
    );
  }

  LineChartData mainData2(List<HistoryLog> logs) {
    return LineChartData(
      clipData: const FlClipData.all(),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: ColorTheme.primaryAlpha_10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets2,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
        // lineTouchData: LineTouchData(
        //   touchTooltipData: LineTouchTooltipData(
        //     tooltipBgColor: ColorTheme.primary,
        //     getTooltipItems: (touchedSpots) {
        //       return touchedSpots.map((LineBarSpot touchedSpot) {
        //         final TextStyle textStyle = TextStyle(
        //           color: ColorTheme.fontColor,
        //           fontWeight: FontWeight.w500,
        //           fontFamily: "Helvetica",
        //           fontStyle: FontStyle.normal,
        //           fontSize: 12.0.sp,
        //         );
        //         return LineTooltipItem(
        //             touchedSpot.y.toStringAsFixed(1),
        //             textStyle,
        //             textAlign: TextAlign.center);
        //       }).toList();
        //     },
        //   ),
        //   handleBuiltInTouches: true,
        // ),
      minX: getChartMinX(logs).toDouble(),
      maxX: getChartMaxX(logs).toDouble(),
      minY: getChartMinY2(logs).toDouble(),
      maxY: getChartMaxY2(logs).toDouble(),
      lineBarsData: getLineCharts2(logs),
    );
  }

  int getChartMaxY(List<HistoryLog> logs) {
    switch (selectIndex) {
      case 0:
        var map = logs.map((e) => e.valveAngle);
        return map.reduce(max) + 10;
      case 1:
        var map = logs.map((e) => (e.strainGauge * torqueFormat).toInt());
        return map.reduce(max) + 10;
      case 2:
        var map = logs.map((e) => (e.pressure * pressureFormat).toInt());
        return map.reduce(max) + 10;
      case 3:
        var map = logs.map((e) => (e.pressure * pressureFormat).toInt());
        return map.reduce(max) + 10;
      default:
        return 0;
    }
  }

  int getChartMaxY2(List<HistoryLog> logs) {
    switch (selectIndex) {
      case 0:
        var map = logs.map((e) => e.valveAngle);
        return map.reduce(max) + 10;
      case 1:
        var map = logs.map((e) => (e.strainGauge * torqueFormat).toInt());
        return map.reduce(max) + 10;
      case 2:
        var map = logs.map((e) => (e.pressure * pressureFormat).toInt());
        return map.reduce(max) + 10;
      case 3:
        var map = logs.map((e) => (e.strainGauge * torqueFormat).toInt());
        return map.reduce(max) + 10;
      default:
        return 0;
    }
  }

  int getChartMinY(List<HistoryLog> logs) {
    switch (selectIndex) {
      case 0:
        var map = logs.map((e) => e.valveAngle);
        return map.reduce(min) - 10;
      case 1:
        var map = logs.map((e) => (e.strainGauge * torqueFormat).toInt());
        return map.reduce(min) - 10;
      case 2:
        var map = logs.map((e) => (e.pressure * pressureFormat).toInt());
        return map.reduce(min) - 10;
      case 3:
        var map = logs.map((e) => (e.pressure * pressureFormat).toInt());
        return map.reduce(min) - 10;
      default:
        return 0;
    }
  }

  int getChartMinY2(List<HistoryLog> logs) {
    switch (selectIndex) {
      case 0:
        var map = logs.map((e) => e.valveAngle);
        return map.reduce(min) - 10;
      case 1:
        var map = logs.map((e) => (e.strainGauge * torqueFormat).toInt());
        return map.reduce(min) - 10;
      case 2:
        var map = logs.map((e) => (e.pressure * pressureFormat).toInt());
        return map.reduce(min) - 10;
      case 3:
        var map = logs.map((e) => (e.strainGauge * torqueFormat).toInt());
        return map.reduce(min) - 10;
      default:
        return 0;
    }
  }

  int getChartMaxX(List<HistoryLog> logs) {
    var map = logs.map((e) => e.index);
    return map.reduce(max);
  }

  int getChartMinX(List<HistoryLog> logs) {
    var map = logs.map((e) => e.index);
    return map.reduce(min);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String dateFormat = '';
    final datum = (meta.max - meta.min).toInt() ~/ 6;
    if (value.toInt() % datum == 0) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000,
          isUtc: true);
      dateFormat = DateFormat("MM/dd").format(dateTime);
    }
    Widget text = Text(dateFormat,
        style: TextStyle(
            color: ColorTheme.primary,
            fontWeight: FontWeight.w300,
            fontFamily: "Helvetica",
            fontStyle: FontStyle.normal,
            fontSize: 10.0.sp),
        textAlign: TextAlign.left);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String title = '';
    String unit = '';
    final datum = (meta.max - meta.min).toInt() ~/ 6;
    if (value.toInt() % datum == 0) {
      title = value.toInt().toString();
      // switch (selectIndex) {
      //   case 0:
      //     title = value.toInt().toString();
      //     unit = '°';
      //     break;
      //   case 1:
      //     title = (value * torqueFormat).toStringAsFixed(1);
      //     unit = " $torqueUnit";
      //     break;
      //   case 2:
      //     title = (value * pressureFormat).toStringAsFixed(1);
      //     unit = " $pressureUnit";
      //     break;
      //   case 3:
      //     title = (value * torqueFormat).toStringAsFixed(1);
      //     unit = " $torqueUnit";
      //     break;
      // }
    }
    Widget text = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text("$title$unit",
          style: TextStyle(
              color: ColorTheme.primary,
              fontWeight: FontWeight.w300,
              fontFamily: "Helvetica",
              fontStyle: FontStyle.normal,
              fontSize: 10.0.sp),
          textAlign: TextAlign.left),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets2(double value, TitleMeta meta) {
    Widget text = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text('',
          style: TextStyle(
              color: ColorTheme.primary,
              fontWeight: FontWeight.w300,
              fontFamily: "Helvetica",
              fontStyle: FontStyle.normal,
              fontSize: 10.0.sp),
          textAlign: TextAlign.left),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  List<LineChartBarData> getLineCharts(List<HistoryLog> logs) {
    List<LineChartBarData> list = List.empty(growable: true);
    switch (selectIndex) {
      case 0:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.valveAngle.toDouble()))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
      case 1:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.strainGauge * torqueFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
      case 2:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.pressure * pressureFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
      case 3:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.strainGauge * torqueFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.pressure * pressureFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[1], getChartLineColor()[1]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[1], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
    }

    return list;
  }

  List<LineChartBarData> getLineCharts2(List<HistoryLog> logs) {
    List<LineChartBarData> list = List.empty(growable: true);
    switch (selectIndex) {
      case 0:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.valveAngle.toDouble()))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
      case 1:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
                  FlSpot(value.index.toDouble(), value.strainGauge * torqueFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
      case 2:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
                  FlSpot(value.index.toDouble(), value.pressure * pressureFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
      case 3:
        list.add(LineChartBarData(
          spots: logs
              .map((value) =>
              FlSpot(value.index.toDouble(), value.strainGauge * torqueFormat))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [getChartLineColor()[0], getChartLineColor()[0]],
          ),
          barWidth: 2.w,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getChartLineColor()[0], Colors.white]
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ));
        break;
    }

    return list;
  }

  List<Color> getChartLineColor() {
    List<Color> colors = List.empty(growable: true);
    switch (selectIndex) {
      case 0:
        colors.add(ColorTheme.green);
        break;
      case 1:
        colors.add(ColorTheme.blueLight);
        break;
      case 2:
        colors.add(ColorTheme.greenLight);
        break;
      case 3:
        colors.add(ColorTheme.blueLight);
        colors.add(ColorTheme.greenLight);
        break;
    }
    return colors;
  }
}
