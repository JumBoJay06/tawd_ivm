import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../../data/fw_info.dart';
import '../../data/shared_preferences/my_shared_preferences.dart';
import '../../manager/ivm_manager.dart';

part 'firmware_update_info_state.dart';

class FirmwareUpdateInfoCubit extends Cubit<FirmwareUpdateInfoState> {
  FirmwareUpdateInfoCubit() : super(FirmwareUpdateInfoInitial());
  final Logger _logger = Logger('FirmwareUpdateInfoCubit');
  List<int> binData = List.empty();
  //-----
  final String binVersionName = 'MS2108_v1_0_t11';
  final String _binAssertKey = "assets/bin/MS2108_v1_0_t11.bin";

  void getFwInfo() async {
    // todo 未來bin檔應該會以API的方式取得，也在這個地方實作，視情況新增state
    // todo bin的名稱與byteArray都放在全域變數，讓外部透過這個來取得
    emit(OnLoading());
    final fwLastUpdateDateTimestamp = MySharedPreferences.getInstance().getFwLastUpdateDate();
    final pairedDateTime = DateTime.fromMillisecondsSinceEpoch(
        fwLastUpdateDateTimestamp ?? 0,
        isUtc: true);
    final fwLastUpdateDateFormat =
    DateFormat("MM/dd/yyyy").format(pairedDateTime);
    final fwLastUpdateDate = fwLastUpdateDateTimestamp != 0 ? fwLastUpdateDateFormat : '--';
    final version = await IvmManager.getInstance().getVersion() ?? '--';
    bool isHasNewVersion;
    try {
      final byteData = await rootBundle.load(_binAssertKey);
      binData = byteData.buffer.asUint8List().toList();
      isHasNewVersion = binData.isNotEmpty;
    } catch (e) {
      _logger.shout("get bin fail:$e", e);
      isHasNewVersion = false;
    }
    emit(OnGetFwInfo(FwInfo(fwLastUpdateDate, version, isHasNewVersion)));
  }
}
