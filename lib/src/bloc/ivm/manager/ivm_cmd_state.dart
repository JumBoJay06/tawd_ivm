part of 'ivm_cmd_bloc.dart';

@immutable
abstract class IvmCmdState {}

class IvmCmdInitial extends IvmCmdState {}

class IvmCmdSend extends IvmCmdState {}

class IvmCmdError extends IvmCmdState {
  final String? message;

  IvmCmdError(this.message);
}

class GetVersion extends IvmCmdState {
  final String? version;

  GetVersion(this.version);
}
