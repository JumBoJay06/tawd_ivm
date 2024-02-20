import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/data/Maintenance_records_data.dart';
import 'package:tawd_ivm/src/data/about_device_data.dart';

import '../../manager/ivm_manager.dart';

part 'ivm_maintenance_records_state.dart';

class IvmMaintenanceRecordsCubit extends Cubit<IvmMaintenanceRecordsState> {
  IvmMaintenanceRecordsCubit() : super(IvmMaintenanceRecordsInitial());

  void loadMaintenanceRecords(BuildContext context) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      final manufacturingDate = await manager.getManufacturingDate();
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          (manufacturingDate ?? 0) * 1000,
          isUtc: true);
      final manufacturingDateFormat =
          DateFormat("MM/dd/yyyy").format(dateTime);
      final totalUsed = await manager.getValveTotalUsed() ?? 0;
      final pairingDataHistory = await manager.getPairingDataHistory();
      var last = pairingDataHistory?.last;
      final ivmId = last?.valveId ?? "--";
      final pairedDateTime = DateTime.fromMillisecondsSinceEpoch(
          (last?.timestamp ?? 0) * 1000,
          isUtc: true);
      final pairedDateFormat =
          DateFormat("MM/dd/yyyy").format(pairedDateTime);
      final cycleCount = last?.totalUsed ?? 0;

      List<Item> ivmInfo = List.empty(growable: true);
      ivmInfo.add(Item(
        'IVM ID',
        manager.device?.platformName ?? '--',
        iconAsset: 'assets/icon_ivm.png',
      ));
      ivmInfo.add(Item('Manufacturing date',
          manufacturingDate != null ? manufacturingDateFormat : '--',
          iconAsset: 'assets/icon_date_ball.png'));
      ivmInfo.add(Item('IVM total use', "$totalUsed time(s)",
          iconAsset: 'assets/icon_ivm_user.png'));

      List<Item> currentValve = List.empty(growable: true);
      currentValve
          .add(Item('Ball Valve ID', ivmId, iconAsset: 'assets/icon_ball.png'));
      currentValve.add(Item(
        'Pairing date',
        last != null ? pairedDateFormat : '--',
        iconAsset: 'assets/icon_date_bel.png',
      ));
      currentValve.add(Item('Cycle counter', "$cycleCount time(s)",
          iconAsset: 'assets/icon_ball_time.png'));

      List<PairingLog> logs = List.empty(growable: true);
      pairingDataHistory?.forEach((element) {
        final pairedDateTime = DateTime.fromMillisecondsSinceEpoch(
            element.timestamp * 1000,
            isUtc: true);
        final pairedDateFormat =
        DateFormat("MM/dd/yyyy").format(pairedDateTime);
        logs.add(PairingLog(pairedDateFormat, element.valveId, element.totalUsed));
      });

      emit(Success(MaintenanceRecords(ivmInfo, currentValve, logs)));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
