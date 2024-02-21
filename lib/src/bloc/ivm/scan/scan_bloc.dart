import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/util/mac_address_util.dart';

import '../../../manager/ivm_manager.dart';

part 'scan_event.dart';

part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    List<ScanResult> myScanResults = List.empty();
    IvmManager.getInstance().scanStream.listen((results) {
      if (results.isEmpty) return;
      myScanResults = myScanResults.toSet().union(results.toSet()).toList();
      myScanResults.removeWhere((element) {
        return !MacAddressUtil.isMacAddress(element.device.platformName);
      });
    }, onError: (e) {
      add(Failure(e.toString()));
    });

    on<ScanStart>((event, emit) async {
      emit(ScanStarting(true));
      myScanResults = List.empty();
      await IvmManager.getInstance().startScan(8);
      await Future.delayed(Duration(seconds: event.timeout), () {
        if (myScanResults.isEmpty) {
          emit(ScanFailure('empty'));
        } else {
          emit(ScanSuccess(myScanResults));
        }
      });
    });

    on<Filter>((event, emit) {
      var filter = event.filter;
      if (filter.isEmpty) {
        emit(ScanSuccess(myScanResults));
      } else {
        final newResults = myScanResults
            .where((element) => element.device.platformName.contains(filter))
            .toList();
        emit(FilterResults(newResults));
      }
    });

    on<Failure>((event, emit) {
      emit(ScanFailure(event.message));
    });

    on<ScanStop>((event, emit) {
      IvmManager.getInstance().stopScan();
    });
  }
}
