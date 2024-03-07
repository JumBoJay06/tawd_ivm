import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/data/history_log.dart';

import '../../../generated/l10n.dart';
import '../../data/about_device_data.dart';
import '../../data/record_chart.dart';
import '../../manager/ivm_manager.dart';
import '../../util/mac_address_util.dart';

part 'record_chart_state.dart';

class RecordChartCubit extends Cubit<RecordChartState> {
  RecordChartCubit() : super(RecordChartInitial());

  void loadRecordChart(BuildContext context) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      String ivmId = '--';
      if (manager.device != null) {
        ivmId = MacAddressUtil.getMacAddressText(manager.device!.platformName);
      }
      final manufacturingDate = await manager.getManufacturingDate();
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          (manufacturingDate ?? 0) * 1000,
          isUtc: true);
      final manufacturingDateFormat =
          DateFormat("MM/dd/yyyy").format(dateTime);
      final pairingDataHistory = await manager.getPairingDataHistory();
      var last = pairingDataHistory?.last;
      final valveId = last?.valveId ?? "--";

      List<Item> ivmInfo = List.empty(growable: true);
      ivmInfo.add(Item(
        'IVM ID',
        ivmId,
        iconAsset: 'assets/icon_ivm.png',
      ));
      ivmInfo.add(Item(S.of(context).about_device_date_manufacture,
          manufacturingDate != null ? manufacturingDateFormat : '--',
          iconAsset: 'assets/icon_date_ball.png'));
      ivmInfo
          .add(Item(S.of(context).about_device_ball_id, valveId, iconAsset: 'assets/icon_ball.png'));

      // todo 單位轉換
      var logs = await manager.getHistoryLog() ?? List.empty();
      emit(Success(RecordChart(ivmInfo, logs)));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
