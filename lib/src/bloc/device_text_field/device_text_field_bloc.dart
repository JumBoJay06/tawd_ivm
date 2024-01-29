import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'device_text_field_event.dart';
part 'device_text_field_state.dart';

class DeviceTextFieldBloc extends Bloc<DeviceTextFieldEvent, DeviceTextFieldState> {
  DeviceTextFieldBloc() : super(DeviceTextFieldInitial()) {

    on<StartFilter>((event, emit) {
      emit(DeviceTextFieldStart());
    });

    on<StopFilter>((event, emit) {
      emit(DeviceTextFieldInitial());
    });
  }
}
