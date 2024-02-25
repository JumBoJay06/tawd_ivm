part of 'firmware_update_info_cubit.dart';

@immutable
abstract class FirmwareUpdateInfoState {}

class FirmwareUpdateInfoInitial extends FirmwareUpdateInfoState {}

class OnLoading extends FirmwareUpdateInfoState {}

class OnGetFwInfo extends FirmwareUpdateInfoState {
  final FwInfo fwInfo;

  OnGetFwInfo(this.fwInfo);
}