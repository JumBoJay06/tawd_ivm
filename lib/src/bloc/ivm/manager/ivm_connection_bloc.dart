import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/main.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'ivm_connection_event.dart';
part 'ivm_connection_state.dart';

class IvmConnectionBloc extends Bloc<IvmConnectionEvent, IvmConnectionState> {
  Logger get _logger => Logger("IvmConnectionBloc");
  IvmConnectionBloc() : super(IvmConnectionInitial()) {

    on<IvmConnect>((event, emit) async {
      emit(IvmConnectionStateChange(event.device, IvmConnectionStatus.connecting));
      await IvmManager.getInstance().connect(event.device);
      emit.forEach(event.device.connectionState, onData: (event) {
        _logger.info("$event");
        switch (event) {
          case BluetoothConnectionState.connected:
            return IvmConnectionStateChange(IvmManager.getInstance().device!, IvmConnectionStatus.connected);
          case BluetoothConnectionState.disconnected:
            return IvmConnectionStateChange(IvmManager.getInstance().device!, IvmConnectionStatus.disconnected);
          default:
            return IvmConnectionStateChange(IvmManager.getInstance().device!, IvmConnectionStatus.disconnected);
        }
      });
    });

    on<IvmDisconnect>((event, emit) async {
      await IvmManager.getInstance().disconnect();
      emit(IvmConnectionStateChange(IvmManager.getInstance().device!, IvmConnectionStatus.disconnected));
    });
  }
}
