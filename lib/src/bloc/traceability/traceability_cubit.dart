import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'traceability_state.dart';

class TraceabilityCubit extends Cubit<TraceabilityState> {
  TraceabilityCubit() : super(TraceabilityInitial());

  void checkValveId() async {
    var list = await IvmManager.getInstance().getPairingDataHistory() ?? List.empty();
    if (list.isNotEmpty) {
      emit(HadValveId(list.last.valveId));
    } else {
      emit(WithoutValveId());
    }
  }
}
