import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../manager/data/led_indicator_state.dart';
import '../../manager/ivm_manager.dart';

part 'ivm_led_indicator_state.dart';

class IvmLedIndicatorCubit extends Cubit<IvmLedIndicatorState> {
  IvmLedIndicatorCubit() : super(IvmLedIndicatorInitial());

  void loadLedIndicatorData() async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      var ledIndicatorState = await manager.getLedIndicatorState();
      if (ledIndicatorState != null) {
      emit(Success(ledIndicatorState));
      } else {
        emit(Fail(Exception('without led data')));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setLedIndicatorData(LedIndicatorState data) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      var result = await manager.setLedIndicatorState(data) ?? false;
      if (result) {
        emit(Success(data));
      } else {
        emit(Fail(Exception('set Device location fail')));
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
