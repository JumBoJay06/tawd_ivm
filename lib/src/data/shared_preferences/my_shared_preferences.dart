import 'package:shared_preferences/shared_preferences.dart';

import '../enum_util.dart';

class MySharedPreferences {
  static final MySharedPreferences _instance = MySharedPreferences._();
  static MySharedPreferences getInstance() => _instance;
  SharedPreferences? _prefs;
  
  /// 程式內單位以Nm為主，其他都在view層轉換
  final String _torqueUnitKey = 'torque_unit'; // Nm、kgf*cm
  final String _torqueLimitMaxKey = 'torque_limit_max';
  final String _torqueLimitMinKey = 'torque_limit_min';
  
  /// 程式內單位以psi為主，其他都在view層轉換
  final String _pressureUnitKey = 'pressure_unit'; // psi、kPa、bar
  final String _pressureLimitMaxKey = 'pressure_limit_max';
  final String _pressureLimitMinKey = 'pressure_limit_min';

  final String _valvePositionMaxKey = 'valve_position_max';
  final String _valvePositionMinKey = 'valve_position_min';

  final String _fwLastUpdateDate = 'fw_last_update_date';
  
  MySharedPreferences._();
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  TorqueUnit getTorqueUnit() {
    return TorqueUnit.fromInt((_prefs!.getInt(_torqueUnitKey) ?? 0));
  }

  Future<bool> setTorqueUnit(TorqueUnit unit) {
    return _prefs!.setInt(_torqueUnitKey, unit.id);
  }
  
  int getTorqueLimitMax() {
    return _prefs!.getInt(_torqueLimitMaxKey) ?? 400;
  }
  
  Future<bool> setTorqueLimitMax(int max) {
    return _prefs!.setInt(_torqueLimitMaxKey, max);
  }
  
  int getTorqueLimitMin() {
    return _prefs!.getInt(_torqueLimitMinKey) ?? 100;
  }
  
  Future<bool> setTorqueLimitMin(int min) {
    return _prefs!.setInt(_torqueLimitMinKey, min);
  }

  PressureUnit getPressureUnit() {
    return PressureUnit.fromInt(_prefs!.getInt(_pressureUnitKey) ?? 0);
  }
  
  Future<bool> setPressureUnit(PressureUnit unit) {
    return _prefs!.setInt(_pressureUnitKey, unit.id);
  }

  int getPressureLimitMax() {
    return _prefs!.getInt(_pressureLimitMaxKey) ?? 30;
  }

  Future<bool> setPressureLimitMax(int max) {
    return _prefs!.setInt(_pressureLimitMaxKey, max);
  }

  int getPressureLimitMin() {
    return _prefs!.getInt(_pressureLimitMinKey) ?? 0;
  }

  Future<bool> setPressureLimitMin(int min) {
    return _prefs!.setInt(_pressureLimitMinKey, min);
  }

  int getValvePositionMax() {
    return _prefs!.getInt(_valvePositionMaxKey) ?? 90;
  }

  Future<bool> setValvePositionMax(int max) async {
    return _prefs!.setInt(_valvePositionMaxKey, max);
  }

  int getValvePositionMin() {
    return _prefs!.getInt(_valvePositionMinKey) ?? 0;
  }

  Future<bool> setValvePositionMin(int min) async {
    return _prefs!.setInt(_valvePositionMinKey, min);
  }

  int getFwLastUpdateDate() {
    return _prefs!.getInt(_fwLastUpdateDate) ?? 0;
  }

  Future<bool> setFwLastUpdateDate(int count) {
    return _prefs!.setInt(_fwLastUpdateDate, count);
  }
}