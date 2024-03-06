import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawd_ivm/src/data/device_setting.dart';
import 'package:tawd_ivm/src/data/shared_preferences/my_shared_preferences.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

import '../../../generated/l10n.dart';

part 'ivm_device_setting_state.dart';

class IvmDeviceSettingCubit extends Cubit<IvmDeviceSettingState> {
  IvmDeviceSettingCubit() : super(IvmDeviceSettingInitial());

  void loadDeviceSettingTitle(BuildContext context) async {
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
      final valvePositionSensorLimit = await manager.getValvePositionSensorLimit();
      final valvePositionSensorMax = valvePositionSensorLimit?.angleMax ?? 0;
      final valvePositionSensorMin = valvePositionSensorLimit?.angleMin ?? 0;
      final strainGaugeLimit = await manager.getStrainGaugeLimit();
      await prefs.setTorqueLimitMax(strainGaugeLimit?.max ?? 400);
      await prefs.setTorqueLimitMin(strainGaugeLimit?.min ?? 100);
      final strainGaugeMax = prefs.getTorqueLimitMax() * torqueFormat;
      final strainGaugeMin = prefs.getTorqueLimitMin() * torqueFormat;
      final barometricPressureSensorLimit = await manager
          .getBarometricPressureSensorLimit();
      await prefs.setPressureLimitMax(barometricPressureSensorLimit?.max.toInt() ?? 30);
      await prefs.setPressureLimitMin(barometricPressureSensorLimit?.min.toInt() ?? 0);
      final barometricPressureSensorMax = prefs.getPressureLimitMax() * pressureFormat;
      final barometricPressureSensorMin = prefs.getPressureLimitMin() * pressureFormat;

      emit(Success(DeviceSetting(
          valveTorque: Item(
              'assets/icon_torque.png', S.of(context).device_settings_valve_torque, content1: "${S.of(context).device_settings_unit} : $torqueUnit", content2: "${S.of(context).device_settings_limit} : $strainGaugeMin~$strainGaugeMax"),
        emissionDetection: Item('assets/icon_emission.png', S.of(context).device_settings_emission_detection, content1: "${S.of(context).device_settings_unit} : $pressureUnit", content2: "${S.of(context).device_settings_limit} : $barometricPressureSensorMin~$barometricPressureSensorMax"),
        valvePosition: Item('assets/icon_switch.png', S.of(context).device_settings_valve_position, content1: '${S.of(context).device_settings_close} : $valvePositionSensorMin°', content2: '${S.of(context).device_settings_open} : $valvePositionSensorMax°'),
        deviceLocation: Item('assets/icon_location_info.png', S.of(context).device_settings_device_lacation),
        ledIndicator: Item('assets/icon_light.png', S.of(context).device_settings_led_indicator),
        replaceBallValve: Item('assets/icon_ball_replace.png', S.of(context).replace_ball_valve)
      )));
    } catch (e) {
      emit(Fail(e));
    }
  }
}
