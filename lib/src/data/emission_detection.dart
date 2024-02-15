import 'enum_util.dart';

class EmissionDetection {
  final PressureUnit unit;
  final int max;
  final int min;

  EmissionDetection(this.unit, this.max, this.min);
}