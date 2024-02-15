import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/replace_ball_valve.dart';
import '../../manager/ivm_manager.dart';

part 'ivm_replace_ball_valve_state.dart';

class IvmReplaceBallValveCubit extends Cubit<IvmReplaceBallValveState> {
  IvmReplaceBallValveCubit() : super(IvmReplaceBallValveInitial());

  void loadReplaceBallValveData() async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      final name = manager.device?.platformName ?? '--';
      final list = await manager.getPairingDataHistory() ?? List.empty();
      if (list.isEmpty) {
        emit(Success(ReplaceBallValve(name, '--')));
      } else {
       final last = list.last;
       emit(Success(ReplaceBallValve(name, last.valveId)));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setReplaceBallValveData(String data) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      final name = manager.device?.platformName ?? '--';
      var result = await manager.setBallValvePairingId(data) ?? false;
      if (result) {
        emit(Success(ReplaceBallValve(name, data)));
      } else {
        emit(Fail(Exception('set id fail')));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
