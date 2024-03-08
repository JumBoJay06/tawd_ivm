import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/data/barometric_pressure_sensor_limit.dart';

import '../../data/emission_detection.dart';
import '../../data/shared_preferences/my_shared_preferences.dart';
import '../../manager/ivm_manager.dart';

part 'ivm_emission_detection_state.dart';

class IvmEmissionDetectionCubit extends Cubit<IvmEmissionDetectionState> {
  IvmEmissionDetectionCubit() : super(IvmEmissionDetectionInitial());

  var max = 0;
  var min = 0;
  void loadEmissionDetectionData() async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      emit(Success(EmissionDetection(prefs.getPressureUnit(),
          prefs.getPressureLimitMax(), prefs.getPressureLimitMin())));
      max = prefs.getPressureLimitMax();
      min = prefs.getPressureLimitMin();
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }

  void setEmissionDetectionMax(int newMax) {
    max = newMax;
  }

  void setEmissionDetectionMin(int newMin) {
    min = newMin;
  }

  void setEmissionDetectionData(EmissionDetection data) async {
    emit(Loading());
    try {
      if (data.max < data.min) {
        throw Exception('max value must be greater than min value');
      }
      if (data.max < 0 || data.min < 0) {
        throw Exception('value must be greater than 0');
      }
      if (data.max > 19 || data.min > 19) {
        throw Exception('value must be less than 19');
      }
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
