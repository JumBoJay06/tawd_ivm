part of 'ivm_valve_torque_cubit.dart';

@immutable
abstract class IvmValveTorqueState {}

class IvmValveTorqueInitial extends IvmValveTorqueState {}

class Loading extends IvmValveTorqueInitial {}

class Success extends IvmValveTorqueInitial {
  final ValveTorque data;

  Success(this.data);
}

class Fail extends IvmValveTorqueInitial {
  final Exception e;

  Fail(this.e);
}