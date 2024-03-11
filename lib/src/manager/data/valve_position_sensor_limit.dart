import 'package:tawd_ivm/src/manager/util/int_to_bytes.dart';

class ValvePositionSensorLimit {
  final int angleMax;
  final int angleMin;
  final int SSC2;
  final int SSC3;
  final int delay;

  ValvePositionSensorLimit(
  this.angleMin, this.angleMax, this.SSC2, this.SSC3, this.delay);

  List<int> toList() {
    return List.empty(growable: true)
      ..addAll(IntToBytes.convertToIntList(angleMin, 2))
      ..addAll(IntToBytes.convertToIntList(angleMax, 2))
      ..addAll(IntToBytes.convertToIntList(SSC2, 2))
      ..addAll(IntToBytes.convertToIntList(SSC3, 2))
      ..add(delay);
  }
}
