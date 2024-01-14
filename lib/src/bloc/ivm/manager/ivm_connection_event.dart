part of 'ivm_connection_bloc.dart';

@immutable
abstract class IvmConnectionEvent {}

class IvmConnect extends IvmConnectionEvent {
  final BluetoothDevice device;
  IvmConnect(this.device);
}

class IvmDisconnect extends IvmConnectionEvent {}

class IvmConnected extends IvmConnectionEvent {}
