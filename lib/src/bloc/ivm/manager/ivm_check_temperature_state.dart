part of 'ivm_check_temperature_cubit.dart';

@immutable
abstract class IvmCheckTemperatureState {}

class IvmGetTemperatureInitial extends IvmCheckTemperatureState {}

class IvmCmdSend extends IvmCheckTemperatureState {}

class IvmCmdError extends IvmCheckTemperatureState {
  final String? message;

  IvmCmdError(this.message);
}

class IvmCmdResult extends IvmCheckTemperatureState {
  final bool isTooHigh;

  IvmCmdResult(this.isTooHigh);
}
