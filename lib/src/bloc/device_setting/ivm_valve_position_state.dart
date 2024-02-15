part of 'ivm_valve_position_cubit.dart';

@immutable
abstract class IvmValvePositionState {}

class IvmValvePositionInitial extends IvmValvePositionState {}

class Loading extends IvmValvePositionInitial {}

class Success extends IvmValvePositionInitial {
  final ValvePosition data;

  Success(this.data);
}

class Fail extends IvmValvePositionInitial {
  final Exception e;

  Fail(this.e);
}