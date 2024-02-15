part of 'ivm_device_location_cubit.dart';

@immutable
abstract class IvmDeviceLocationState {}

class IvmDeviceLocationInitial extends IvmDeviceLocationState {}

class Loading extends IvmDeviceLocationInitial {}

class Success extends IvmDeviceLocationInitial {
  final String data;

  Success(this.data);
}

class Fail extends IvmDeviceLocationInitial {
  final Exception e;

  Fail(this.e);
}