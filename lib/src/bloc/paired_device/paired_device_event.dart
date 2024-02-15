part of 'paired_device_bloc.dart';

@immutable
abstract class PairedDeviceEvent {}

class GetPairedDevices extends PairedDeviceEvent {}

class Filter extends PairedDeviceEvent {
  final String filter;

  Filter(this.filter);
}

class GetPairedDeviceByName extends PairedDeviceEvent {
  final String deviceName;

  GetPairedDeviceByName(this.deviceName);
}
