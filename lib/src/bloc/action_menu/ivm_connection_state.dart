part of 'ivm_connection_cubit.dart';

@immutable
abstract class IvmConnectionState {}

class IvmConnectionInitial extends IvmConnectionState {}

class Connecting extends IvmConnectionState {}

class Connected extends IvmConnectionState {}

// 4次連線失敗後，才會吐這個
class Disconnected extends IvmConnectionState {}
