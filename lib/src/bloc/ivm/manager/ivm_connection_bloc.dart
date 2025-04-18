import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/main.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/util/mac_address_util.dart';

import '../../../data/paired_device.dart';

part 'ivm_connection_event.dart';

part 'ivm_connection_state.dart';

class IvmConnectionBloc extends Bloc<IvmConnectionEvent, IvmConnectionState> {
  Logger get _logger => Logger("IvmConnectionBloc");

  IvmConnectionBloc() : super(IvmConnectionInitial()) {
    on<IvmConnect>((event, emit) async {
      var device = event.device;
      emit(IvmConnectionStateChange(device, IvmConnectionStatus.connecting));
      try {
        await IvmManager.getInstance().connect(device);
      } catch (e) {
        _logger.warning('connect', e);
        emit(IvmConnectionStateChange(IvmManager.getInstance().device!,
            IvmConnectionStatus.disconnected));
        return;
      }
      await emit.forEach(device.connectionState, onData: (event) {
        _logger.info("$event");
        switch (event) {
          case BluetoothConnectionState.connected:
            final box = Hive.box<PairedDevice>('PairedDevice');
            IvmManager.getInstance().getDeviceLocation().then((value) {
              PairedDevice pairedDevice = box.values.firstWhere(
                      (element) => element.name == device.platformName,
                  orElse: () =>
                      PairedDevice(id: box.length, name: device.platformName));
              pairedDevice.location = value ?? '--';
              if (box.length == pairedDevice.id) {
                box.add(pairedDevice);
              } else {
                box.putAt(pairedDevice.id, pairedDevice);
              }
            });

            return IvmConnectionStateChange(IvmManager.getInstance().device!,
                IvmConnectionStatus.connected);
          case BluetoothConnectionState.disconnected:
            return IvmConnectionStateChange(IvmManager.getInstance().device!,
                IvmConnectionStatus.disconnected);
          default:
            return IvmConnectionStateChange(IvmManager.getInstance().device!,
                IvmConnectionStatus.disconnected);
        }
      });
    });

    on<IvmDisconnect>((event, emit) async {
      await IvmManager.getInstance().disconnect();
      emit(IvmConnectionStateChange(
          IvmManager.getInstance().device!, IvmConnectionStatus.disconnected));
    });
  }
}
