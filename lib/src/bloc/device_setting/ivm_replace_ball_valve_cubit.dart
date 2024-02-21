import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/replace_ball_valve.dart';
import '../../manager/ivm_manager.dart';
import '../../util/mac_address_util.dart';

part 'ivm_replace_ball_valve_state.dart';

class IvmReplaceBallValveCubit extends Cubit<IvmReplaceBallValveState> {
  IvmReplaceBallValveCubit() : super(IvmReplaceBallValveInitial());

  void loadReplaceBallValveData() async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      String ivmId = '--';
      if (manager.device != null) {
        ivmId = MacAddressUtil.getMacAddressText(manager.device!.platformName);
      }
      final list = await manager.getPairingDataHistory() ?? List.empty();
      if (list.isEmpty) {
        emit(Success(ReplaceBallValve(ivmId, '--')));
      } else {
       final last = list.last;
       emit(Success(ReplaceBallValve(ivmId, last.valveId)));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setReplaceBallValveData(String data) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      String ivmId = '--';
      if (manager.device != null) {
        ivmId = MacAddressUtil.getMacAddressText(manager.device!.platformName);
      }
      var result = await manager.setBallValvePairingId(data) ?? false;
      if (result) {
        emit(Success(ReplaceBallValve(ivmId, data)));
      } else {
        emit(Fail(Exception('set id fail')));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
