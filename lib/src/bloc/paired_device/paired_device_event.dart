part of 'paired_device_bloc.dart';

@immutable
abstract class PairedDeviceEvent {}

class GetPairedDevice extends PairedDeviceEvent {}

class Filter extends PairedDeviceEvent {
  final String filter;

  Filter(this.filter);
}
