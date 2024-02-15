part of 'device_text_field_bloc.dart';

@immutable
abstract class DeviceTextFieldEvent {}

class StartFilter extends DeviceTextFieldEvent {}

class StopFilter extends DeviceTextFieldEvent {}
