import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/data/shared_preferences/my_shared_preferences.dart';
import 'package:tawd_ivm/src/manager/data/strain_gauge_limit.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

import '../../data/valve_torque.dart';

part 'ivm_valve_torque_state.dart';

class IvmValveTorqueCubit extends Cubit<IvmValveTorqueState> {
  IvmValveTorqueCubit() : super(IvmValveTorqueInitial());

  void loadValveTorqueData() async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      emit(Success(ValveTorque(prefs.getTorqueUnit(), prefs.getTorqueLimitMax(),
          prefs.getTorqueLimitMin())));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setValveTorqueData(ValveTorque data) async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      await prefs.setTorqueUnit(data.unit);
      final manager = IvmManager.getInstance();
      final result = await manager
          .setStrainGaugeLimit(StrainGaugeLimit(data.max, data.min)) ?? false;
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
