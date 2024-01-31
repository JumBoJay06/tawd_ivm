part of 'ivm_emission_detection_cubit.dart';

@immutable
abstract class IvmEmissionDetectionState {}

class IvmEmissionDetectionInitial extends IvmEmissionDetectionState {}

class Loading extends IvmEmissionDetectionInitial {}

class Success extends IvmEmissionDetectionInitial {
  final EmissionDetection data;

  Success(this.data);
}

class Fail extends IvmEmissionDetectionInitial {
  final Exception e;

  Fail(this.e);
}