part of 'paired_device_bloc.dart';

@immutable
abstract class PairedDeviceState {
  final List<PairedDevice> deviceList;

  PairedDeviceState(this.deviceList);
}

class PairedDeviceInitial extends PairedDeviceState {
  final List<PairedDevice> deviceList;

  PairedDeviceInitial(this.deviceList) : super(deviceList);
}

class PairedDeviceList extends PairedDeviceState {
  final List<PairedDevice> deviceList;

  PairedDeviceList(this.deviceList) : super(deviceList);
}

class FilterPairedDeviceList extends PairedDeviceState {
  final List<PairedDevice> deviceList;

  FilterPairedDeviceList(this.deviceList) : super(deviceList);
}
