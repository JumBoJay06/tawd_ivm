import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    FlutterBluePlus.scanResults.listen((results) {
      if (results.isEmpty) return;
      add(Success(results));
    }, onError: (e) {
      add(Failure(e.toString()));
    });

    on<ScanStart>((event, emit) async {
      emit(ScanStarting(true));
      await FlutterBluePlus.startScan(withServices: event.serviceUuids, timeout: Duration(seconds: event.timeout));
    });

    on<Success>((event, emit) {
      emit(ScanSuccess(event.scanResults));
    });

    on<Failure>((event, emit) {
      emit(ScanFailure(event.message));
    });

    on<ScanStop>((event, emit) {
      FlutterBluePlus.stopScan();
    });
  }
}
