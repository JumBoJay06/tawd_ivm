
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tawd_ivm/src/view/ads_page.dart';
import 'package:tawd_ivm/src/view/language/select_language_page.dart';
import 'package:tawd_ivm/src/view/scan/available_devices_page.dart';
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
const String kRouteScanPage = '/scan/scan';

Map<String, WidgetBuilder> getRoutes() {
  return {
    kRouteAds: (context) => const AdsPage(),
    kRouteScanPage: (context) => const ScanPage(),
    kRouteScanStartPage: (context) => const ScanStartPage(),
    kRouteAvailableDevicesPage: (context) => const AvailableDevicesPage(),
    kRouteSelectLanguage: (context) => const SelectLanguagePage(),
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
