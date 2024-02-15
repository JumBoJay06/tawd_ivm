import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/data/barometric_pressure_sensor_limit.dart';

import '../../data/emission_detection.dart';
import '../../data/shared_preferences/my_shared_preferences.dart';
import '../../manager/ivm_manager.dart';

part 'ivm_emission_detection_state.dart';

class IvmEmissionDetectionCubit extends Cubit<IvmEmissionDetectionState> {
  IvmEmissionDetectionCubit() : super(IvmEmissionDetectionInitial());

  void loadEmissionDetectionData() async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      emit(Success(EmissionDetection(prefs.getPressureUnit(),
          prefs.getPressureLimitMax(), prefs.getPressureLimitMin())));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setEmissionDetectionData(EmissionDetection data) async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      await prefs.setPressureUnit(data.unit);
      final manager = IvmManager.getInstance();
      final result = await manager
              .setBarometricPressureSensorLimit(BarometricPressureSensorLimit(data.max.toDouble(), data.min.toDouble())) ??
          false;
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
