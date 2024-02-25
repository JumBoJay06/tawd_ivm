part of 'firmware_update_cubit.dart';

@immutable
abstract class FirmwareUpdateState {}

class FirmwareUpdateInitial extends FirmwareUpdateState {}

class OnUpdating extends FirmwareUpdateState {}

class OnSuccess extends FirmwareUpdateState {}

class OnFail extends FirmwareUpdateState {}
