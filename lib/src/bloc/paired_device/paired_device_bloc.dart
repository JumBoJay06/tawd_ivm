import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../data/paired_device.dart';

part 'paired_device_event.dart';

part 'paired_device_state.dart';

class PairedDeviceBloc extends Bloc<PairedDeviceEvent, PairedDeviceState> {
  PairedDeviceBloc() : super(PairedDeviceInitial(List.empty())) {
    on<GetPairedDevices>((event, emit) {
      final box = Hive.box<PairedDevice>('PairedDevice');
      final deviceList = box.values.toList();
      emit(PairedDeviceList(deviceList));
    });

    on<Filter>((event, emit) {
      final box = Hive.box<PairedDevice>('PairedDevice');
      final deviceList = box.values.toList();
      if (event.filter.isEmpty) {
        emit(PairedDeviceList(deviceList));
        return;
      }
      final newDeviceList = deviceList
          .where((element) => element.name.contains(event.filter))
          .toList();
      emit(FilterPairedDeviceList(newDeviceList));
    });

    on<GetPairedDeviceByName>((event, emit) {
      final box = Hive.box<PairedDevice>('PairedDevice');
      final deviceList = box.values.toList();
      var findDevice =
          deviceList.firstWhere((element) => element.name == event.deviceName);
      emit(FindDevice(deviceList, findDevice));
    });
  }
}
