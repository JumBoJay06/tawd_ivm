import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/data/shared_preferences/my_shared_preferences.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'firmware_update_state.dart';

class FirmwareUpdateCubit extends Cubit<FirmwareUpdateState> {
  FirmwareUpdateCubit() : super(FirmwareUpdateInitial());

  final Logger _logger = Logger('FirmwareUpdateCubit');

  void startFwUpdate(List<int> binData, String versionName) async {
    // todo 韌體更新，更新次數要更新
    emit(OnUpdating());
    if (binData.isEmpty) {
      _logger.shout("startFwUpdate: binData isEmpty");
      emit(OnFail());
      return;
    }
    final manager = IvmManager.getInstance();
    final fwInfo = await manager.switchToFwMode();
    if (fwInfo == null) {
      _logger.shout("startFwUpdate: switchToFwMode fail");
      emit(OnFail());
      return;
    }
    final isReady = await manager.setFwParameter();
    if (!isReady) {
      _logger.shout("startFwUpdate: setFwParameter fail");
      emit(OnFail());
      return;
    }
    final isTransmissionComplete = await manager.sendFwData(binData);
    if (!isTransmissionComplete) {
      _logger.shout("startFwUpdate: sendFwData fail");
      emit(OnFail());
      return;
    }
    manager.isReboot = true;
    final isReboot = await manager.reBoot();
    if (!isReboot) {
      _logger.shout("startFwUpdate: reBoot fail");
      manager.isReboot = false;
      emit(OnFail());
      return;
    }

    Future.delayed(const Duration(seconds: 5), () async {
      var isConnected = await manager.connect(manager.device!);
      if (!isConnected) {
        _logger.shout("startFwUpdate: reConnect fail");
        manager.isReboot = false;
        emit(OnFail());
        return;
      }
      manager.isReboot = false;
      var newVersion = await manager.getVersion();
      if (newVersion != versionName) {
        _logger.shout("startFwUpdate: version fail");
        emit(OnFail());
      }
      final currentTime = DateTime.now();
      final currentTimeUtc = currentTime.millisecondsSinceEpoch;
      await MySharedPreferences.getInstance().setFwLastUpdateDate(currentTimeUtc);
      emit(OnSuccess());
    });


  }
}
