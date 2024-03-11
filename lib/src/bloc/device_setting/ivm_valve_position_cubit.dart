import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/data/valve_position_sensor_limit.dart';

import '../../data/shared_preferences/my_shared_preferences.dart';
import '../../data/valve_position.dart';
import '../../manager/ivm_manager.dart';

part 'ivm_valve_position_state.dart';

class IvmValvePositionCubit extends Cubit<IvmValvePositionState> {
  IvmValvePositionCubit() : super(IvmValvePositionInitial());
  var max = 0;
  var min = 0;
  void loadValvePositionData() async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      emit(Success(ValvePosition(
          prefs.getValvePositionMax(), prefs.getValvePositionMin())));
      max = prefs.getValvePositionMax();
      min = prefs.getValvePositionMin();
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setValvePositionMax(int newMax) {
    max = newMax;
  }

  void setValvePositionMin(int newMin) {
    min = newMin;
  }

  void setValvePositionData(ValvePosition data) async {
    emit(Loading());
    try {
      if (data.max < data.min) {
        throw Exception('max value must be greater than min value');
      }
      if (data.max < 0 || data.min < 0) {
        throw Exception('value must be greater than 0');
      }
      if (data.max > 360 || data.min > 360) {
        throw Exception('value must be less than 360');
      }
      final manager = IvmManager.getInstance();
      var valvePositionSensorLimit =
          await manager.getValvePositionSensorLimit();
      final result = await manager.setValvePositionSensorLimit(
              ValvePositionSensorLimit(
                  data.max,
                  data.min,
                  valvePositionSensorLimit?.SSC2 ?? 0,
                  valvePositionSensorLimit?.SSC3 ?? 0,
                  valvePositionSensorLimit?.delay ?? 0)) ?? false;
      if (result) {
        emit(Success(data));
      } else {
        throw Exception('set data fail');
      }
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
