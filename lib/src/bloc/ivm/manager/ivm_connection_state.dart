part of 'ivm_connection_bloc.dart';

@immutable
abstract class IvmConnectionState {}

enum IvmConnectionStatus {
  disconnected,
  connecting,
  connected,
}

class IvmConnectionInitial extends IvmConnectionState {}

class IvmConnectionStateChange extends IvmConnectionState {
  final BluetoothDevice device;
  final IvmConnectionStatus state;

  IvmConnectionStateChange(this.device, this.state);
}
