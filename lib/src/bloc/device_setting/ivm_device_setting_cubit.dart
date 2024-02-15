import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawd_ivm/src/data/device_setting.dart';
import 'package:tawd_ivm/src/data/shared_preferences/my_shared_preferences.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

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
              'assets/icon_torque.png', 'Valve torque', content1: "Unit : $torqueUnit", content2: "Limit : $strainGaugeMin~$strainGaugeMax"),
        emissionDetection: Item('assets/icon_emission.png', 'Emission detection', content1: "Unit : $pressureUnit", content2: "Limit : $barometricPressureSensorMin~$barometricPressureSensorMax"),
        valvePosition: Item('assets/icon_switch.png', 'Valve position', content1: 'Close : $valvePositionSensorMin°', content2: 'Open : $valvePositionSensorMax°'),
        deviceLocation: Item('assets/icon_location_info.png', 'Device location'),
        ledIndicator: Item('assets/icon_light.png', 'LED indicator'),
        replaceBallValve: Item('assets/icon_ball_replace.png', 'Replace Ball Valve')
      )));
    } catch (e) {
      emit(Fail(e));
    }
  }
}
