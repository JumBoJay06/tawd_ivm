import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/data/enum_util.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

import '../../data/automated_testing_result.dart';

part 'automated_testing_state.dart';

class AutomatedTestingCubit extends Cubit<AutomatedTestingState> {
  AutomatedTestingCubit() : super(AutomatedTestingInitial());

  void startTest() async {
    emit(Loading(AutomatedTestingResult(
      ItemState.init,
      ItemState.init,
      ItemState.init,
      ItemState.init,
      false,
    )));
    final manager = IvmManager.getInstance();
    var valvePositionSensor = await manager.getValvePositionSensor();
    var strainGauge = await manager.getStrainGauge();
    var barometricPressureSensor = await manager.getBarometricPressureSensor();
    var temperature = await manager.getTemperature();
    emit(Done(AutomatedTestingResult(
        valvePositionSensor != null ? ItemState.success : ItemState.fail,
        strainGauge != null ? ItemState.success : ItemState.fail,
        barometricPressureSensor != null ? ItemState.success : ItemState.fail,
        temperature != null ? ItemState.success : ItemState.fail,
        valvePositionSensor != null &&
            strainGauge != null &&
            barometricPressureSensor != null &&
            temperature != null)));
  }
}
