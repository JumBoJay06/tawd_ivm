import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'ivm_check_temperature_state.dart';

class IvmCheckTemperatureCubit extends Cubit<IvmCheckTemperatureState> {
  IvmCheckTemperatureCubit() : super(IvmGetTemperatureInitial());
  
  void getTemperature() async {
    emit(IvmCmdSend());
    final temp = await IvmManager.getInstance().getTemperature();
    if (temp != null) {
      emit(IvmCmdResult(temp > 85));
    } else {
      emit(IvmCmdError("取得溫度失敗"));
    }
  }
}
