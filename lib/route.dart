

import 'package:flutter/material.dart';
import 'package:tawd_ivm/src/view/action_menu/about_device/about_device_page.dart';
import 'package:tawd_ivm/src/view/action_menu/action_menu_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/device_location_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/device_setting_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/emission_detection_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/led_indicator_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/replace_ball_valve_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/valve_position_page.dart';
import 'package:tawd_ivm/src/view/action_menu/device_setting/valve_torque_page.dart';
import 'package:tawd_ivm/src/view/action_menu/maintenance_records/maintenance_records_page.dart';
import 'package:tawd_ivm/src/view/action_menu/record_chart/record_chart_page.dart';
import 'package:tawd_ivm/src/view/ads_page.dart';
import 'package:tawd_ivm/src/view/language/select_language_page.dart';
import 'package:tawd_ivm/src/view/scan/available_devices_page.dart';
import 'package:tawd_ivm/src/view/scan/paired_page.dart';
import 'package:tawd_ivm/src/view/scan/scan_page.dart';
import 'package:tawd_ivm/src/view/scan/scan_start_page.dart';

/// 轉場動畫
enum TransitionType {
  /// 預設動畫
  normal,

  /// 無動畫
  withoutTransition,

  /// 由下往上轉場
  slideTop,

  /// 由上往下轉場
  slideDown,

  /// 由右往左轉場
  slideLeft
}

const String kRouteAds = '/';
const String kRouteSelectLanguage = '/select_language';
const String kRouteScanStartPage = '/scan/start';
const String kRouteAvailableDevicesPage = '/scan/available_devices';
const String kRoutePairedPage = '/scan/paired_page';
const String kRouteActionMenu = '/action_menu';
const String kRouteAboutDevicePage = '/action_menu/about_device';
const String kRouteMaintenanceRecordsPage = '/action_menu/about_device/maintenance_records';
const String kRouteDeviceSettingPage = '/action_menu/device_setting_page';
const String kRouteValveTorquePage = '/action_menu/device_setting/valve_torque_page';
const String kRouteEmissionDetectionPage = '/action_menu/device_setting/emission_detection_page';
const String kRouteValvePositionPage = '/action_menu/device_setting/valve_position_page';
const String kRouteDeviceLocationPage = '/action_menu/device_setting/device_location_page';
const String kRouteLedIndicatorPage = '/action_menu/device_setting/led_indicator_page';
const String kRouteReplaceBallValvePage = '/action_menu/device_setting/replace_ball_valve_page';
const String kRouteRecordChartPage = '/action_menu/record_chart_page';

Map<String, WidgetBuilder> getRoutes() {
  return {
    kRouteAds: (context) => const AdsPage(),
    kRouteScanStartPage: (context) => const ScanStartPage(),
    kRouteAvailableDevicesPage: (context) => const AvailableDevicesPage(),
    kRoutePairedPage: (context) => const PairedPage(),
    kRouteSelectLanguage: (context) => const SelectLanguagePage(),
    kRouteActionMenu: (context) => const ActionMenu(),
    kRouteAboutDevicePage: (context) => const AboutDevicePage(),
    kRouteMaintenanceRecordsPage: (context) => const MaintenanceRecordsPage(),
    kRouteDeviceSettingPage: (context) => const DeviceSettingPage(),
    kRouteValveTorquePage: (context) => const ValveTorquePage(),
    kRouteEmissionDetectionPage: (context) => const EmissionDetectionPage(),
    kRouteValvePositionPage: (context) => const ValvePositionPage(),
    kRouteDeviceLocationPage: (context) => const DeviceLocationPage(),
    kRouteLedIndicatorPage: (context) => const LedIndicatorPage(),
    kRouteReplaceBallValvePage: (context) => const ReplaceBallValvePage(),
    kRouteRecordChartPage: (context) => const RecordChartPage(),
  };
}

Route<dynamic> onRoute(RouteSettings settings) {
  final route = getRoutes();
  final args = settings.arguments;
  if (args is Map<String, dynamic> && args.containsKey('page_transition')) {
    final transition = args['page_transition'];
    switch (transition) {
      case TransitionType.withoutTransition:
        return PageRouteBuilder(
          settings: RouteSettings(
              arguments: args['original_arguments'], name: settings.name),
          pageBuilder: (context, _, __) => route[settings.name]!(context),
          transitionDuration: const Duration(seconds: 0),
        );
      case TransitionType.slideTop:
        return PageRouteBuilder(
          settings: RouteSettings(
              arguments: args['original_arguments'], name: settings.name),
          pageBuilder: (context, animation, secondaryAnimation) =>
              route[settings.name]!(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
        );
      case TransitionType.slideDown:
        return PageRouteBuilder(
          settings: RouteSettings(
              arguments: args['original_arguments'], name: settings.name),
          pageBuilder: (context, animation, secondaryAnimation) =>
              route[settings.name]!(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position:
                Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
        );
      case TransitionType.slideLeft:
        return PageRouteBuilder(
          settings: RouteSettings(
              arguments: args['original_arguments'], name: settings.name),
          pageBuilder: (context, animation, secondaryAnimation) =>
              route[settings.name]!(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
        );
    }
  }
  return MaterialPageRoute(builder: route[settings.name]!, settings: settings);
}

extension NavigatorExt on Navigator {
  /// 根據[transition]來實現動畫
  static Future<T?> pushNamedWithTransition<T extends Object>(
      BuildContext context, String routeName,
      {Object? arguments, TransitionType transition = TransitionType.normal}) {
    return Navigator.pushNamed<T?>(context, routeName, arguments: {
      'original_arguments': arguments,
      'page_transition': transition
    });
  }

  static Future<T?>
  pushReplacementNamedWithTransition<T extends Object, TO extends Object>(
      BuildContext context, String routeName,
      {Object? arguments,
        TransitionType transition = TransitionType.normal}) {
    return Navigator.pushReplacementNamed<T?, TO?>(context, routeName,
        arguments: {
          'original_arguments': arguments,
          'page_transition': transition
        });
  }
}
