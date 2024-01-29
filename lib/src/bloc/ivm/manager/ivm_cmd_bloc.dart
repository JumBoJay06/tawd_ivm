import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/main.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'ivm_cmd_event.dart';
part 'ivm_cmd_state.dart';

class IvmCmdBloc extends Bloc<IvmCmdEvent, IvmCmdState> {
  Logger get _logger => Logger("IvmCmdBloc");
  IvmCmdBloc() : super(IvmCmdInitial()) {
    on<CmdGetVersion>((event, emit) async {
      try {
        emit(IvmCmdSend());
        IvmManager.getInstance().getRS485Address();
        final version = await IvmManager.getInstance().getVersion();

        _logger.info("Version: $version");
        emit(GetVersion(version));
      } catch (e) {
        _logger.shout(e.toString(), e, StackTrace.current);
        emit(IvmCmdError(e.toString()));
      }
    });
  }
}
