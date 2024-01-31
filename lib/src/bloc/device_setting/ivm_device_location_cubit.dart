import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

import '../../data/paired_device.dart';

part 'ivm_device_location_state.dart';

class IvmDeviceLocationCubit extends Cubit<IvmDeviceLocationState> {
  IvmDeviceLocationCubit() : super(IvmDeviceLocationInitial());

  void loadDeviceLocationData() async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      var location = await manager.getDeviceLocation() ?? '';
      final box = Hive.box<PairedDevice>('PairedDevice');
      PairedDevice pairedDevice = box.values.firstWhere(
              (element) => element.name == manager.device!.platformName);
      pairedDevice.location = location;
      await box.putAt(pairedDevice.id, pairedDevice);
      emit(Success(location));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setDeviceLocationData(String data) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      var result = await manager.setDeviceLocation(data) ?? false;
      if (result) {
        var location = await manager.getDeviceLocation() ?? '';
        final box = Hive.box<PairedDevice>('PairedDevice');
        PairedDevice pairedDevice = box.values.firstWhere(
                (element) => element.name == manager.device!.platformName);
        pairedDevice.location = location;
        await box.putAt(pairedDevice.id, pairedDevice);
        emit(Success(data));
      } else {
        emit(Fail(Exception('set Device location fail')));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
