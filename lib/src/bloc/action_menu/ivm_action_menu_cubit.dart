import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../data/paired_device.dart';
import '../../manager/ivm_manager.dart';

part 'ivm_action_menu_state.dart';

class IvmActionMenuCubit extends Cubit<IvmActionMenuState> {
  IvmActionMenuCubit() : super(IvmActionMenuInitial());

  void loadActionMenuData() async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      final box = Hive.box<PairedDevice>('PairedDevice');
      final deviceList = box.values.toList();
      var findDevice =
      deviceList.firstWhere((element) => element.name == manager.device!.platformName);
      emit(Success(findDevice.name, findDevice.location));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
