part of 'ivm_led_indicator_cubit.dart';

@immutable
abstract class IvmLedIndicatorState {}

class IvmLedIndicatorInitial extends IvmLedIndicatorState {}

class Loading extends IvmLedIndicatorInitial {}

class Success extends IvmLedIndicatorInitial {
  final LedIndicatorState data;

  Success(this.data);
}

class Fail extends IvmLedIndicatorInitial {
  final e;

  Fail(this.e);
}