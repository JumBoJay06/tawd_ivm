part of 'ivm_about_device_cubit.dart';

@immutable
abstract class IvmAboutDeviceState {}

class IvmAboutDeviceInitial extends IvmAboutDeviceState {}

class Loading extends IvmAboutDeviceState {}

class Success extends IvmAboutDeviceState {
  final List<AboutDeviceData> data;

  Success(this.data);
}

class Fail extends IvmAboutDeviceState {
  final Exception e;

  Fail(this.e);
}
