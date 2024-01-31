part of 'ivm_device_setting_cubit.dart';

@immutable
abstract class IvmDeviceSettingState {}

class IvmDeviceSettingInitial extends IvmDeviceSettingState {}

class Loading extends IvmDeviceSettingInitial {}

class Success extends IvmDeviceSettingInitial {
  final DeviceSetting data;

  Success(this.data);
}

class Fail extends IvmDeviceSettingInitial {
  final e;

  Fail(this.e);
}