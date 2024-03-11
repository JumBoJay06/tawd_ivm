import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';
import 'package:tawd_ivm/src/theme/style.dart';
import 'package:tawd_ivm/src/util/mac_address_util.dart';

import '../../../generated/l10n.dart';
import '../../data/about_device_data.dart';
import '../../data/shared_preferences/my_shared_preferences.dart';

part 'ivm_about_device_state.dart';

class IvmAboutDeviceCubit extends Cubit<IvmAboutDeviceState> {
  IvmAboutDeviceCubit() : super(IvmAboutDeviceInitial());

  void loadAboutDeviceData(BuildContext context) async {
    emit(Loading());
    try {
      final MySharedPreferences prefs = MySharedPreferences.getInstance();
      final isTorqueUnitNm = prefs.getTorqueUnit().id == 0;
      final torqueUnit = isTorqueUnitNm ? 'Nm' : 'kgf*cm';
      final torqueFormat = isTorqueUnitNm ? 1 : 10.2;
      final pressureUnitSetting = prefs.getPressureUnit().id;
      String pressureUnit;
      double pressureFormat;
      switch (pressureUnitSetting) {
        case 1:
          pressureUnit = 'bar';
          pressureFormat = 0.07;
          break;
        case 2:
          pressureUnit = 'kPa';
          pressureFormat = 7;
          break;
        default:
          pressureUnit = 'psi';
          pressureFormat = 1;
          break;
      }
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
      final torque = (strainGauge * torqueFormat).toStringAsFixed(1);
      final strainGaugeLimit = await manager.getStrainGaugeLimit();
      final torqueMax = ((strainGaugeLimit?.max ?? 0) * torqueFormat).toStringAsFixed(1);
      final torqueMin = ((strainGaugeLimit?.min ?? 0) * torqueFormat).toStringAsFixed(1);
      final barometricPressureSensor =
          await manager.getBarometricPressureSensor() ?? 0;
      final pressure = (barometricPressureSensor * pressureFormat).toStringAsFixed(1);
      final barometricPressureSensorLimit =
      await manager.getBarometricPressureSensorLimit();
      final pressureMax = ((barometricPressureSensorLimit?.max ?? 0) * pressureFormat).toStringAsFixed(1);
      final pressureMin = ((barometricPressureSensorLimit?.min ?? 0) * pressureFormat).toStringAsFixed(1);
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
      productInfoList.add(Item(S.of(context).about_device_date_manufacture,
          manufacturingDate != null ? manufacturingDateFormat : '--',
          iconAsset: 'assets/icon_date_ball.png'));
      productInfoList.add(Item(S.of(context).about_device_ball_id, valveId,
          iconAsset: 'assets/icon_ball.png', isShowError: last?.valveId == null));
      productInfoList.add(Item(
        S.of(context).about_device_matching_date,
        last != null ? pairedDateFormat : '--',
        iconAsset: 'assets/icon_date_bel.png',
      ));

      List<Item> valveInfoList = List.empty(growable: true);
      valveInfoList.add(Item(
        S.of(context).about_device_angle,
        "${inductivePositionSensor?.angle ?? 0}° (${inductivePositionSensorLimit?.angleMin ?? 0}°~${inductivePositionSensorLimit?.angleMax ?? 0}°)",
        iconAsset: 'assets/icon_angle.png',
      ));
      valveInfoList.add(Item(
        S.of(context).about_device_torque,
        "$torque $torqueUnit ($torqueMin~$torqueMax $torqueUnit)",
        iconAsset: 'assets/icon_torque.png',
      ));
      valveInfoList.add(Item(
        S.of(context).about_device_emission_detection,
        "$pressure $pressureUnit ($pressureMin~$pressureMax $pressureUnit)",
        iconAsset: 'assets/icon_emission.png',
      ));
      valveInfoList.add(Item(
        S.of(context).about_device_cycle_counter,
        "${last?.totalUsed ?? 0} time(s)",
        iconAsset: 'assets/icon_ball_time.png',
      ));
      valveInfoList.add(Item(S.of(context).about_device_total_use, "$totalUsed ${S.of(context).common_times}",
          iconAsset: 'assets/icon_ivm_user.png'));

      List<Item> ledIndicatorList = List.empty(growable: true);
      ledIndicatorList.add(Item(S.of(context).device_settings_led_abnormal, S.of(context).device_settings_led_short_flash,
          ledIndicatorColor:
          ledIndicatorState?.error.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_maintenande_notify, S.of(context).device_settings_led_long_flash,
          ledIndicatorColor:
          ledIndicatorState?.maintain.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_valve_open, S.of(context).device_settings_led_constant,
          ledIndicatorColor:
          ledIndicatorState?.valveOpen.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_valve_close, S.of(context).device_settings_led_constant,
          ledIndicatorColor:
          ledIndicatorState?.valveClose.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_rs485_disconnected, S.of(context).device_settings_led_short_flash,
          ledIndicatorColor: ledIndicatorState?.RS485Disconnect.toColor() ??
              ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_rs485_connected, S.of(context).device_settings_led_breathing,
          ledIndicatorColor:
          ledIndicatorState?.RS485Connected.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_ble_disconnected, S.of(context).device_settings_led_short_flash,
          ledIndicatorColor:
          ledIndicatorState?.bleDisconnect.toColor() ?? ColorTheme.primary));
      ledIndicatorList.add(Item(S.of(context).device_settings_led_ble_connected, S.of(context).device_settings_led_breathing,
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
