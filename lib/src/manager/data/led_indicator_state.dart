import 'dart:ui';

import 'package:tawd_ivm/src/manager/util/digits_util.dart';
import 'package:tawd_ivm/src/theme/style.dart';

class LedIndicatorState {
  LedColor SSC3;
  LedColor SSC2;
  LedColor error;
  LedColor maintain;
  LedColor valveOpen;
  LedColor valveClose;
  LedColor RS485Disconnect;
  LedColor RS485Connected;
  LedColor bleDisconnect;
  LedColor bleConnected;

  LedIndicatorState(
      this.SSC3,
      this.SSC2,
      this.error,
      this.maintain,
      this.valveOpen,
      this.valveClose,
      this.RS485Disconnect,
      this.RS485Connected,
      this.bleDisconnect,
      this.bleConnected);

  static LedIndicatorState fromList(List<int> data) {
    final map = data.map((value) => DigitsUtil.extractDigits(value)).toList();

    return LedIndicatorState(
        LedColor.fromInt(map[0][0]),
        LedColor.fromInt(map[0][1]),
        LedColor.fromInt(map[1][0]),
        LedColor.fromInt(map[1][1]),
        LedColor.fromInt(map[2][0]),
        LedColor.fromInt(map[2][1]),
        LedColor.fromInt(map[3][0]),
        LedColor.fromInt(map[3][1]),
        LedColor.fromInt(map[4][0]),
        LedColor.fromInt(map[4][1]));
  }

  List<int> toList() {
    return List<int>.generate(5, (index) {
      int current;
      switch (index) {
        case 0:
          current = DigitsUtil.combineDigits(SSC3.id, SSC3.id);
          break;
        case 1:
          current = DigitsUtil.combineDigits(error.id, maintain.id);
          break;
        case 2:
          current = DigitsUtil.combineDigits(valveOpen.id, valveClose.id);
          break;
        case 3:
          current =
              DigitsUtil.combineDigits(RS485Disconnect.id, RS485Connected.id);
          break;
        case 4:
          current = DigitsUtil.combineDigits(bleDisconnect.id, bleConnected.id);
          break;
        default:
          current = 255;
          break;
      }
      return current;
    });
  }
}

/// 1-blue(藍)、2-cyan(靛青)、3-green(綠)、4-magenta(洋紅)、
/// 5-red(紅)、6-white(白)、7-yellow(黃)
enum LedColor {
  blue(1),
  cyan(2),
  green(3),
  magenta(4),
  red(5),
  white(6),
  yellow(7);

  final int id;

  const LedColor(this.id);

  static LedColor fromInt(int value) {
    return LedColor.values.firstWhere((element) => element.id == value);
  }

  Color toColor() {
    Color color = ColorTheme.white;
    switch (this) {
      case LedColor.blue:
        color = ColorTheme.blue;
        break;
      case LedColor.cyan:
        color = ColorTheme.cyan;
        break;
      case LedColor.green:
        color = ColorTheme.green;
        break;
      case LedColor.magenta:
        color = ColorTheme.magenta;
        break;
      case LedColor.red:
        color = ColorTheme.red;
        break;
      case LedColor.white:
        color = ColorTheme.white;
        break;
      case LedColor.yellow:
        color = ColorTheme.yellow;
        break;
    }

    return color;
  }
}
