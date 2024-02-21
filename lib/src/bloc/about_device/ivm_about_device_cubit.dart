import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/theme/style.dart';
import 'package:tawd_ivm/src/util/mac_address_util.dart';

import '../../../generated/l10n.dart';
import '../../data/about_device_data.dart';

part 'ivm_about_device_state.dart';

class IvmAboutDeviceCubit extends Cubit<IvmAboutDeviceState> {
  IvmAboutDeviceCubit() : super(IvmAboutDeviceInitial());

  void loadAboutDeviceData(BuildContext context) async {
    emit(Loading());
    try {
      final manager = IvmManager.getInstance();
      final manufacturingDate = await manager.getManufacturingDate();
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          (manufacturingDate ?? 0) * 1000,
          isUtc: true);
      final manufacturingDateFormat = DateFormat("MM / dd / yyyy").format(dateTime);
      final pairingDataHistory = await manager.getPairingDataHistory();
      var last = pairingDataHistory?.last;
      final valveId = last?.valveId ?? "--";
      final pairedDateTime = DateTime.fromMillisecondsSinceEpoch(
          (last?.timestamp ?? 0) * 1000,
          isUtc: true);
      final pairedDateFormat = DateFormat("MM / dd / yyyy").format(pairedDateTime);
      final inductivePositionSensor = await manager.getValvePositionSensor();
      final inductivePositionSensorLimit =
      await manager.getValvePositionSensorLimit();
      final strainGauge = await manager.getStrainGauge() ?? 0;
      final strainGaugeLimit = await manager.getStrainGaugeLimit();
      final barometricPressureSensor =
          await manager.getBarometricPressureSensor() ?? 0;
      final barometricPressureSensorLimit =
      await manager.getBarometricPressureSensorLimit();
      final totalUsed = await manager.getValveTotalUsed() ?? 0;
      final ledIndicatorState = await manager.getLedIndicatorState();

      List<Item> productInfoList = List.empty(growable: true);
      String ivmId = '--';
      if (manager.device != null) {
        ivmId = MacAddressUtil.getMacAddressText(manager.device!.platformName);
      }
      productInfoList.add(Item(
        'IVM ID',
        ivmId,
        iconAsset: 'assets/icon_ivm.png',
      ));
      productInfoList.add(Item('Manufacturing date',
          manufacturingDate != null ? manufacturingDateFormat : '--',
          iconAsset: 'assets/icon_date_ball.png'));
      productInfoList.add(Item('Ball Valve ID', valveId,
          iconAsset: 'assets/icon_ball.png', isShowError: last?.valveId == null));
      productInfoList.add(Item(
        'Pairing date',
        last != null ? pairedDateFormat : '--',
        iconAsset: 'assets/icon_date_bel.png',
      ));

      List<Item> valveInfoList = List.empty(growable: true);
      valveInfoList.add(Item(
        'Angle',
        "${inductivePositionSensor?.angle ?? 0}° (${inductivePositionSensorLimit?.angleMin ?? 0}°~${inductivePositionSensorLimit?.angleMax ?? 0}°)",
        iconAsset: 'assets/icon_angle.png',
      ));
      // todo 這邊有單位轉換功能
      valveInfoList.add(Item(
        'Torque',
        "$strainGauge Nm (${strainGaugeLimit?.min ?? 0}~${strainGaugeLimit?.max ?? 0} Nm)",
        iconAsset: 'assets/icon_torque.png',
      ));
      valveInfoList.add(Item(
        'Emission detection',
        "$barometricPressureSensor psi (${barometricPressureSensorLimit?.min ?? 0}~${barometricPressureSensorLimit?.max ?? 0} psi)",
        iconAsset: 'assets/icon_emission.png',
      ));
      valveInfoList.add(Item(
        'Cycle counter',
        "${last?.totalUsed ?? 0} time(s)",
        iconAsset: 'assets/icon_ball_time.png',
      ));
      valveInfoList.add(Item('IVM total use', "$totalUsed time(s)",
          iconAsset: 'assets/icon_ivm_user.png'));

      List<Item> ledIndicatorList = List.empty(growable: true);
      ledIndicatorList.add(Item('Abnormal / Fault', 'Short flash',
          ledIndicatorColor:
          ledIndicatorState?.error.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item('Maintenance notice', 'Long flash',
          ledIndicatorColor:
          ledIndicatorState?.maintain.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item('Valve open', 'Constant',
          ledIndicatorColor:
          ledIndicatorState?.valveOpen.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item('Valve close', 'Constant',
          ledIndicatorColor:
          ledIndicatorState?.valveClose.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item('RS485 disconnected', 'Short flash',
          ledIndicatorColor: ledIndicatorState?.RS485Disconnect.toColor() ??
              ColorTheme.primary));
      ledIndicatorList.add(Item('RS485 connected', 'Breathing',
          ledIndicatorColor:
          ledIndicatorState?.RS485Connected.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item('BLE disconnected', 'Short flash',
          ledIndicatorColor:
          ledIndicatorState?.bleDisconnect.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item('BLE connected', 'Breathing',
          ledIndicatorColor:
          ledIndicatorState?.bleConnected.toColor() ?? ColorTheme.primary));

      emit(Success(List<AboutDeviceData>.empty(growable: true)
        ..add(AboutDeviceData(productInfoList))
        ..add(AboutDeviceData(valveInfoList))
        ..add(AboutDeviceData(ledIndicatorList))));
    } catch (e) {
      emit(Fail(e as Exception));
    }
  }
}
