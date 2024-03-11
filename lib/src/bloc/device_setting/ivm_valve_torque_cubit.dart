import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/data/enum_util.dart';
import 'package:tawd_ivm/src/data/shared_preferences/my_shared_preferences.dart';
import 'package:tawd_ivm/src/manager/data/strain_gauge_limit.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

import '../../data/valve_torque.dart';

part 'ivm_valve_torque_state.dart';

class IvmValveTorqueCubit extends Cubit<IvmValveTorqueState> {
  IvmValveTorqueCubit() : super(IvmValveTorqueInitial());
  var max = 0;
  var min = 0;
  void loadValveTorqueData() async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      final valveTorque = ValveTorque(prefs.getTorqueUnit(), prefs.getTorqueLimitMax(),
          prefs.getTorqueLimitMin());
      max = prefs.getTorqueLimitMax();
      min = prefs.getTorqueLimitMin();
      emit(Success(valveTorque));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setValveTorqueMax(int newMax) {
    max = newMax;
  }

  void setValveTorqueMin(int newMin) {
    min = newMin;
  }

  void sendValveTorqueData(ValveTorque data) async {
    emit(Loading());
    try {
      if (data.max < data.min) {
        throw Exception('max value must be greater than min value');
      }
      if (data.max < 0 || data.min < 0) {
        throw Exception('value must be greater than 0');
      }
      if (data.max > 740 || data.min > 740) {
        throw Exception('value must be less than 740');
      }
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      await prefs.setTorqueUnit(data.unit);
      final manager = IvmManager.getInstance();
      final result = await manager
          .setStrainGaugeLimit(StrainGaugeLimit(data.max.toInt(), data.min.toInt())) ?? false;
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
