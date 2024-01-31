import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/data/led_indicator_state.dart';

part 'led_select_color_state.dart';

class LedSelectColorCubit extends Cubit<LedSelectColorState> {
  LedSelectColorCubit() : super(LedSelectColorInitial());

  void initColor(LedColor color) {
    emit(OnChange(color.id));
  }

  void clickColor(LedColor color) {
    emit(OnChange(color.id));
  }
}
