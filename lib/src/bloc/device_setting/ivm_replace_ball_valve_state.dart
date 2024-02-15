part of 'ivm_replace_ball_valve_cubit.dart';

@immutable
abstract class IvmReplaceBallValveState {}

class IvmReplaceBallValveInitial extends IvmReplaceBallValveState {}

class Loading extends IvmReplaceBallValveInitial {}

class Success extends IvmReplaceBallValveInitial {
  final ReplaceBallValve data;

  Success(this.data);
}

class Fail extends IvmReplaceBallValveInitial {
  final Exception e;

  Fail(this.e);
}