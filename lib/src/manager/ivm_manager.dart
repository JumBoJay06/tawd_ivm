import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/manager/data/fw_info.dart';
import 'package:tawd_ivm/src/manager/data/rs485_baud_rate.dart';
import 'package:tawd_ivm/src/manager/data/valve_position_sensor_limit.dart';
import 'package:tawd_ivm/src/manager/data/barometric_pressure_sensor_limit.dart';
import 'package:tawd_ivm/src/manager/data/history_log.dart';
import 'package:tawd_ivm/src/manager/data/valve_position_sensor.dart';
import 'package:tawd_ivm/src/manager/data/led_indicator_state.dart';
import 'package:tawd_ivm/src/manager/data/maintenance_notification_count.dart';
import 'package:tawd_ivm/src/manager/data/pairing_data.dart';
import 'package:tawd_ivm/src/manager/data/strain_gauge_limit.dart';
import 'package:tawd_ivm/src/manager/util/bytes_to_int.dart';
import 'package:tawd_ivm/src/manager/util/int_to_bytes.dart';
import 'package:tawd_ivm/src/manager/util/list_util.dart';

class IvmManager {
  static final IvmManager _instance = IvmManager._();

  static IvmManager getInstance() => _instance;

  IvmManager._() {
    FlutterBluePlus.scanResults.listen((event) {
      _logger.info(event);
      _scanController.sink.add(event);
    });

  }

  final Guid serviceUuid = Guid("7e400001-b5a3-f393-e0a9-e50e24dcca9e");
  final Guid _writeUuid = Guid("7e400002-b5a3-f393-e0a9-e50e24dcca9e");
  final Guid _notifyUuid = Guid("7e400003-b5a3-f393-e0a9-e50e24dcca9e");

  BluetoothDevice? _device;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;

  BluetoothDevice? get device => _device;
  // 只給FirmwareUpdateCubit控制，讓IvmConnectionCubit知道是否要觸發斷線重連
  bool isReboot = false;

  final StreamController<List<ScanResult>> _scanController =
      StreamController<List<ScanResult>>.broadcast();

  Stream<List<ScanResult>> get scanStream => _scanController.stream;

  late StreamController<List<int>> _rxController;

  Logger get _logger => Logger("IvmManager");

  Future<void> startScan(int timeout) async {
    await FlutterBluePlus.startScan(
        withServices: [serviceUuid], timeout: Duration(seconds: timeout));
  }

  Future<ScanResult?> startScanWithName(String name, int timeout) async {
    final completer = Completer<ScanResult?>();
    FlutterBluePlus.startScan(
        withServices: [serviceUuid],
        withNames: [name],
        timeout: Duration(seconds: timeout));

    StreamSubscription<List<ScanResult>>? subscription;
    subscription = scanStream.listen((event) {
      for (var element in event) {
        if (element.device.platformName == name) {
          completer.complete(element);
          subscription?.cancel();
        }
      }
    });

    await Future.any([
      completer.future,
      Future.delayed(Duration(seconds: timeout), () {
        if (!completer.isCompleted) {
          _logger.warning("not found $name");
          completer.complete(null);
        }
      })
    ]);

    return completer.future.whenComplete(() => subscription?.cancel());
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<bool> connect(BluetoothDevice device,
      {Duration timeout = const Duration(seconds: 8)}) async {
    _device = device;

    try {
      await device.connect(timeout: timeout);

      return await device.discoverServices().then((services) async {
        for (var service in services) {
          if (service.uuid == serviceUuid) {
            for (var characteristic in service.characteristics) {
              if (characteristic.uuid == _writeUuid) {
                _writeCharacteristic = characteristic;
                _logger.info("Discover write characteristic");
              } else if (characteristic.uuid == _notifyUuid) {
                _notifyCharacteristic = characteristic;
                await characteristic.setNotifyValue(true);
                _rxController = StreamController<List<int>>.broadcast();
                characteristic.onValueReceived.listen((value) {
                  _rxController.sink.add(value);
                });
                _logger.info("Discover notify characteristic");
              }
            }
          }
        }
        if (_writeCharacteristic != null && _notifyCharacteristic != null) {
          // 部分指令需要這麼多，但不知道為什麼韌體更新還維持16bytes
          if (Platform.isAndroid) {
            await device.requestMtu(255);
          }
          await setCurrentUTC();
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      _logger.shout(e);
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_device != null) {
      await _device!.disconnect();
      await _rxController.close();
    }
  }

  String? getCurrentDeviceName() {
    return _device?.platformName;
  }

  // 指令都會以下面方式實作，搭配IvmCmdBloc使用
  Future<String?> getVersion() async {
    try {
      final list = await _sendCmd(CmdId.getVersion.id);
      if (list != null) {
        return _fromAscii(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getVersion ${e.toString()}", e);
    }
    return null;
  }

  Future<String?> getRS485Address() async {
    try {
      final list = await _sendCmd(CmdId.getRS485Address.id);
      if (list != null) {
        return _fromAscii(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getRS485Address ${e.toString()}", e);
    }
    return null;
  }

  Future<RS485BaudRate?> getRS485BaudRate() async {
    try {
      final list = await _sendCmd(CmdId.getRS485BaudRate.id);
      if (list != null) {
        final data = list.first;
        return RS485BaudRate.findRate(data);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getRS485BaudRate ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> getTerminatingResistanceSetting() async {
    try {
      final list = await _sendCmd(CmdId.getTerminatingResistanceSetting.id);
      if (list != null) {
        final data = list.first;
        return data != 0;
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getTerminatingResistanceSetting ${e.toString()}", e);
    }

    return null;
  }

  Future<double?> getTemperature() async {
    try {
      final list = await _sendCmd(CmdId.getTemperature.id);
      if (list != null) {
        return BytesToInt.convert(list) / 100.0;
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getTemperature ${e.toString()}", e);
    }

    return null;
  }

  Future<String?> getDeviceLocation() async {
    try {
      final list = await _sendCmd(CmdId.getDeviceLocation.id);
      if (list != null) {
        return _fromAscii(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getDeviceLocation ${e.toString()}", e);
    }

    return null;
  }

  Future<int?> getManufacturingDate() async {
    try {
      final list = await _sendCmd(CmdId.getManufacturingDate.id);
      if (list != null) {
        return BytesToInt.convert(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getManufacturingDate ${e.toString()}", e);
    }

    return null;
  }

  Future<ValvePositionSensor?> getValvePositionSensor() async {
    try {
      final list = await _sendCmd(CmdId.getValvePositionSensor.id);
      if (list != null) {
        return ValvePositionSensor(BytesToInt.convert(list.sublist(0, 2)),
            _intToBool(list[2]), _intToBool(list[3]));
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getInductivePositionSensor ${e.toString()}", e);
    }

    return null;
  }

  Future<List<PairingData>?> getPairingDataHistory() async {
    try {
      final list = await _sendCmd(CmdId.getPairingDataHistory.id);
      if (list != null) {
        List<PairingData> results = List.empty(growable: true);
        var splitList = ListUtil.splitList(list.sublist(1), 25);
        if (splitList.last.length != 25) {
          throw Exception('data size error');
        }
        for (final element in splitList) {
          results.add(PairingData(
              element[0],
              BytesToInt.convert(element.sublist(1, 5)),
              _fromAscii(element.sublist(5, 21)),
              element[21]));
        }
        return results;
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getPairingDataHistory ${e.toString()}", e);
    }

    return null;
  }

  Future<ValvePositionSensorLimit?> getValvePositionSensorLimit() async {
    try {
      final list = await _sendCmd(CmdId.getValvePositionSensorLimit.id);
      if (list != null) {
        return ValvePositionSensorLimit(
            BytesToInt.convert(list.sublist(0, 2)),
            BytesToInt.convert(list.sublist(2, 4)),
            BytesToInt.convert(list.sublist(4, 6)),
            BytesToInt.convert(list.sublist(6, 8)),
            list[8]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getInductivePositionSensorLimit ${e.toString()}", e);
    }

    return null;
  }

  Future<int?> getStrainGauge() async {
    try {
      final list = await _sendCmd(CmdId.getStrainGauge.id);
      if (list != null) {
        return BytesToInt.convert(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getStrainGauge ${e.toString()}", e);
    }

    return null;
  }

  Future<StrainGaugeLimit?> getStrainGaugeLimit() async {
    try {
      final list = await _sendCmd(CmdId.getStrainGaugeLimit.id);
      if (list != null) {
        return StrainGaugeLimit(BytesToInt.convert(list.sublist(0, 4)),
            BytesToInt.convert(list.sublist(4, 8)));
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getStrainGaugeLimit ${e.toString()}", e);
    }

    return null;
  }

  Future<double?> getBarometricPressureSensor() async {
    try {
      final list = await _sendCmd(CmdId.getBarometricPressureSensor.id);
      if (list != null) {
        return BytesToInt.convert(list) / 10000.0;
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getBarometricPressureSensor ${e.toString()}", e);
    }

    return null;
  }

  Future<BarometricPressureSensorLimit?>
      getBarometricPressureSensorLimit() async {
    try {
      final list = await _sendCmd(CmdId.getBarometricPressureSensorLimit.id);
      if (list != null) {
        return BarometricPressureSensorLimit(
            BytesToInt.convert(list.sublist(0, 4)) / 10000.0,
            BytesToInt.convert(list.sublist(4, 8)) / 10000.0);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getBarometricPressureSensorLimit ${e.toString()}", e);
    }

    return null;
  }

  Future<MaintenanceNotificationCount?>
      getMaintenanceNotificationCount() async {
    try {
      final list = await _sendCmd(CmdId.getMaintenanceNotificationCount.id);
      if (list != null) {
        return MaintenanceNotificationCount(
            MaintenanceType.fromInt(list.first),
            BytesToInt.convert(list.sublist(1, 5)),
            BytesToInt.convert(list.sublist(5, 9)));
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getMaintenanceNotificationCount ${e.toString()}", e);
    }
    return null;
  }

  Future<int?> getValveTotalUsed() async {
    try {
      final list = await _sendCmd(CmdId.getValveTotalUsed.id);
      if (list != null) {
        return BytesToInt.convert(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getTotalUsed ${e.toString()}", e);
    }

    return null;
  }

  Future<int?> getOperatingTime() async {
    try {
      final list = await _sendCmd(CmdId.getOperatingTime.id);
      if (list != null) {
        return BytesToInt.convert(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getOperatingTime ${e.toString()}", e);
    }

    return null;
  }

  Future<LedIndicatorState?> getLedIndicatorState() async {
    try {
      final list = await _sendCmd(CmdId.getLedIndicatorState.id);
      if (list != null) {
        return LedIndicatorState.fromList(list);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getLedIndicatorState ${e.toString()}", e);
    }

    return null;
  }

  Future<List<HistoryLog>?> getHistoryLog() async {
    try {
      final list = await _sendCmdAndMultiRx(CmdId.getHistoryLog.id, 20);
      if (list != null) {
        List<HistoryLog> results = List.empty(growable: true);
        for (final element in list) {
          var splitList = ListUtil.splitList(element.sublist(2), 20);
          if (splitList.last.length != 20) {
            throw Exception('data size error');
          }
          for (final data in splitList) {
            results.add(HistoryLog(
                BytesToInt.convert(data.sublist(0, 2)),
                BytesToInt.convert(data.sublist(2, 6)),
                BytesToInt.convert(data.sublist(6, 10)) / 10000.0,
                BytesToInt.convert(data.sublist(10, 14)),
                BytesToInt.convert(data.sublist(14, 18)) / 100.0,
                BytesToInt.convert(data.sublist(18, 20))));
          }
        }
        return results;
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("getHistoryLog ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setRS485Address(int address) async {
    try {
      final list = await _sendCmd(CmdId.setRS485Address.id,
          data: List.empty(growable: true)..add(address));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setRS485Address($address) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setRS485BaudRate(RS485BaudRate rate) async {
    try {
      final list = await _sendCmd(CmdId.setRS485BaudRate.id,
          data: List.empty(growable: true)..add(rate.index));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setRS485BaudRate($rate) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> calibrateStrainGauge() async {
    try {
      final list = await _sendCmd(CmdId.calibrateStrainGauge.id,
          data: List.empty(growable: true)..add(1));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("calibrateStrainGauge() ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setTerminatingResistanceSetting(bool isSetting) async {
    try {
      final list = await _sendCmd(CmdId.setTerminatingResistanceSetting.id,
          data: List.empty(growable: true)..add(_boolToInt(isSetting)));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout(
          "setTerminatingResistanceSetting($isSetting) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setValveSwitchCount(int count) async {
    try {
      var convertCount = IntToBytes.convertToIntList(count, 4);
      final list =
          await _sendCmd(CmdId.setValveSwitchCount.id, data: convertCount);
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setValveSwitchCount($count) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setOperatingTime(int time) async {
    try {
      var convertCount = IntToBytes.convertToIntList(time, 4);
      final list =
          await _sendCmd(CmdId.setOperatingTime.id, data: convertCount);
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setOperatingTime($time) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setLedIndicatorState(LedIndicatorState state) async {
    try {
      final list =
          await _sendCmd(CmdId.setLedIndicatorState.id, data: state.toList());
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setLedIndicatorState($state) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setBallValvePairingId(String id) async {
    try {
      final idToAscii = _toAscii(id);
      final currentTime = DateTime.now();
      final currentTimeUtc = currentTime.millisecondsSinceEpoch ~/ 1000;
      final data = IntToBytes.convertToIntList(currentTimeUtc, 4)
        ..addAll(idToAscii);
      final list = await _sendCmd(CmdId.setBallValvePairingId.id, data: data);
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setBallValvePairingId($id) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setValvePositionSensorLimit(
      ValvePositionSensorLimit limit) async {
    try {
      final list = await _sendCmd(CmdId.setValvePositionSensorLimit.id,
          data: limit.toList());
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setValvePositionSensorLimit($limit) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setStrainGaugeLimit(StrainGaugeLimit limit) async {
    try {
      final data = List<int>.empty(growable: true)
        ..addAll(IntToBytes.convertToIntList(limit.min, 4))
        ..addAll(IntToBytes.convertToIntList(limit.max, 4));
      final list = await _sendCmd(CmdId.setStrainGaugeLimit.id, data: data);
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setStrainGaugeLimit($limit) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setBarometricPressureSensorLimit(
      BarometricPressureSensorLimit limit) async {
    try {
      final data = List<int>.empty(growable: true)
        ..addAll(IntToBytes.convertToIntList((limit.min * 10000).toInt(), 4))
        ..addAll(IntToBytes.convertToIntList((limit.max * 10000).toInt(), 4));
      final list =
          await _sendCmd(CmdId.setBarometricPressureSensorLimit.id, data: data);
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout(
          "setBarometricPressureSensorLimit($limit) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setCurrentUTC() async {
    try {
      final currentTime = DateTime.now();
      final currentTimeUtc = currentTime.millisecondsSinceEpoch ~/ 1000;
      final list = await _sendCmd(CmdId.setCurrentUTC.id,
          data: IntToBytes.convertToIntList(currentTimeUtc, 4));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setCurrentUTC() ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setDeviceLocation(String location) async {
    try {
      var locationToAscii = _toAscii(location);
      final list =
          await _sendCmd(CmdId.setDeviceLocation.id, data: locationToAscii);
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setDeviceLocation($location) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setManufacturingDate(int data) async {
    try {
      final list = await _sendCmd(CmdId.setManufacturingDate.id,
          data: IntToBytes.convertToIntList(data, 4));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("setManufacturingDate($data) ${e.toString()}", e);
    }

    return null;
  }

  Future<bool?> setMaintenanceNotificationCount(
      MaintenanceNotificationCount maintenanceNotificationCount) async {
    try {
      final list = await _sendCmd(CmdId.setMaintenanceNotificationCount.id,
          data: maintenanceNotificationCount.toList());
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout(
          "setMaintenanceNotificationCount($maintenanceNotificationCount) ${e.toString()}",
          e);
    }

    return null;
  }

  Future<bool?> calibrateInductivePositionSensor() async {
    try {
      final list = await _sendCmd(CmdId.calibrateInductivePositionSensor.id,
          data: List.empty(growable: true)..add(1));
      if (list != null) {
        return listEquals(list, [0, 1]);
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("calibrateInductivePositionSensor() ${e.toString()}", e);
    }

    return null;
  }

  /// FW Update F0
  Future<FwInfo?> switchToFwMode() async {
    try {
      final list = await _sendFwCmd(FwCmdId.switchToFwMode.id) ?? List.empty();
      if (list.isNotEmpty) {
        return FwInfo(BytesToInt.convert(list.sublist(0, 4)),
            _fromAscii(list.sublist(4, list.length)));
      } else {
        return null;
      }
    } catch (e) {
      _logger.shout("switchToFwMode() ${e.toString()}", e);
    }
    return null;
  }

  /// FW Update F1
  Future<bool> setFwParameter({bool isStart = true}) async {
    try {
      int isStartFlag = isStart ? 0 : 1;
      var list = await _sendFwCmd(FwCmdId.setFwParameter.id,
              data: List.empty(growable: true)..add(isStartFlag)) ??
          List.empty();
      if (list.isNotEmpty) {
        return listEquals(list.sublist(0, 2), [0, 1]);
      } else {
        return false;
      }
    } catch (e) {
      _logger.shout("setFwParameter() ${e.toString()}", e);
    }
    return false;
  }

  /// FW Update F2
  Future<bool> sendFwData(List<int> data) async {
    try {
      while (data.length % 16 != 0) {
        data.add(0);
      }
      final splitList = ListUtil.splitList(data, 256);
      if (splitList.isEmpty) {
        return false;
      }
      final blockQueue = Queue<List<int>>.from(splitList);
      _logger.info("sendFwData() => block count: ${blockQueue.length} / total size: ${data.length}");
      while (blockQueue.isNotEmpty) {
        final currentBlock = blockQueue.removeFirst();
        _logger.info(
            "sendFwData() => currentBlock: ${splitList.length - blockQueue.length} / ${splitList.length}");
        final currentBlockXor = _xor(currentBlock);
        final packages = ListUtil.splitList(currentBlock, 16);
        final packageQueue = Queue<List<int>>.from(packages);
        _logger.info("sendFwData() => packages count: ${packageQueue.length}");
        while (packageQueue.isNotEmpty) {
          final isLast = packageQueue.length == 1;
          final package = packageQueue.removeFirst();
          _logger.info(
              "sendFwData() => currentPackage: ${packages.length - packageQueue.length} / ${packages.length}");
          if (!isLast) {
            await _sendFwCmdWithoutRx(FwCmdId.sendFwData.id, data: package);
          } else {
            var list = await _sendFwCmd(FwCmdId.sendFwData.id, data: package) ??
                List.empty();
            if (list.isNotEmpty) {
              _logger.info(
                  "sendFwData() => last package: result(${listEquals(list, [
                    0,
                    1
                  ])}), currentBlockXor($currentBlockXor), rxXor()${list[2]}");
              return listEquals(list.sublist(0, 2), [0, 1]) && currentBlockXor == list[2];
            } else {
              _logger.info("sendFwData() => sendFwCmd fail");
              return false;
            }
          }
        }
        return true;
      }
    } catch (e) {
      _logger.shout("sendFwData() ${e.toString()}", e);
    }
    return false;
  }

  /// FW Update F3
  Future<bool> reBoot() async {
    try {
      var list = await _sendFwCmd(FwCmdId.reBoot.id) ?? List.empty();
      if (list.isNotEmpty) {
        return listEquals(list.sublist(0, 2), [0, 1]);
      } else {
        return false;
      }
    } catch (e) {
      _logger.shout("reBoot() ${e.toString()}", e);
    }
    return false;
  }

  Future<List<int>?> _sendFwCmd(int cmdId, {List<int>? data}) {
    final length = data?.length ?? 0;
    if (length > 4095) {
      return Future(() => null);
    }
    var lengthList = IntToBytes.convertToIntList(length, 2).reversed;
    final send = [0x80, ...lengthList, cmdId];
    if (data != null) {
      send.addAll(data);
    }
    return _write(send, isFwUpdate: true);
  }

  Future<bool?> _sendFwCmdWithoutRx(int cmdId, {List<int>? data}) {
    final length = data?.length ?? 0;
    if (length > 4095) {
      return Future(() => null);
    }
    var lengthList = IntToBytes.convertToIntList(length, 2).reversed;
    final send = [0x80, ...lengthList, cmdId];
    if (data != null) {
      send.addAll(data);
    }
    return _writeWithoutRx(send);
  }

  Future<List<int>?> _sendCmd(int cmdId, {List<int>? data}) {
    final length = (data?.length ?? 0) + 2;
    final send = [0x25, length, cmdId];
    if (data != null) {
      send.addAll(data);
    }
    send.add(_xor(send));
    return _write(send);
  }

  Future<List<List<int>>?> _sendCmdAndMultiRx(int cmdId, int chunkSize,
      {List<int>? data}) {
    final length = (data?.length ?? 0) + 2;
    final send = [0x25, length, cmdId];
    if (data != null) {
      send.addAll(data);
    }
    send.add(_xor(send));
    return _writeAndMultiRx(send, chunkSize);
  }

  // 輸入 List<int> ，依序做xor，最後回傳int
  int _xor(List<int> list) {
    int result = 0;
    for (var i = 0; i < list.length; i++) {
      result ^= list[i];
    }
    return result;
  }

  Future<bool> _writeWithoutRx(List<int> send) async {
    try {
      if (_writeCharacteristic == null || _notifyCharacteristic == null) {
        throw Exception("No write characteristic");
      }
      _logger.info("write(${send[2]}) -> ${send.toHexString()}");
      _writeCharacteristic!.write(send, withoutResponse: true);
      _logger.info("write(${send[2]}) -> done");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<int>?> _write(List<int> send, {bool isFwUpdate = false}) async {
    try {
      if (_writeCharacteristic == null || _notifyCharacteristic == null) {
        throw Exception("No write characteristic");
      }
      if (isFwUpdate) {
        _logger.info("write(${send[3]}) -> ${send.toHexString()}");
        _writeCharacteristic!.write(send);
        _logger.info("write(${send[3]}) -> done");
        return await _waitFwRx(send[3]);
      } else {
        _logger.info("write(${send[2]}) -> ${send.toHexString()}");
        _writeCharacteristic!.write(send);
        _logger.info("write(${send[2]}) -> done");
        return await _waitRx(send[2]);
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<List<int>>?> _writeAndMultiRx(
      List<int> send, int chunkSize) async {
    try {
      if (_writeCharacteristic == null || _notifyCharacteristic == null) {
        throw Exception("No write characteristic");
      }
      _logger.info("write(${send[2]}) -> ${send.toHexString()}");
      _writeCharacteristic!.write(send);
      _logger.info("write(${send[2]}) -> done");
      return await _waitMultiRx(send[2], chunkSize);
    } catch (e) {
      return null;
    }
  }

  Future<List<int>?> _waitFwRx(int cmdId) async {
    final completer = Completer<List<int>?>();

    StreamSubscription<List<int>>? subscription;
    subscription = _rxController.stream.listen((value) {
      _logger.info("any value: ${value.toHexString()}");
      if (value[3] == cmdId) {
        _logger.info("fw value($cmdId): ${value.toHexString()}");
        final length = BytesToInt.convert(value.sublist(1, 3).reversed.toList());
        if (length > 0) {
          final data = value.sublist(4, value.length);
          completer.complete(data);
        } else {
          completer.complete(null);
        }
        subscription?.cancel();
      }
    });

    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 8), () {
        if (!completer.isCompleted) {
          _logger.warning("send $cmdId timeout");
          completer.complete(null);
          subscription?.cancel();
        }
      })
    ]);

    return completer.future.whenComplete(() => subscription?.cancel());
  }

  Future<List<int>?> _waitRx(int cmdId) async {
    final completer = Completer<List<int>?>();

    StreamSubscription<List<int>>? subscription;
    subscription = _rxController.stream.listen((value) {
      _logger.info("any value: ${value.toHexString()}");
      if (value[2] == cmdId) {
        _logger.info("value($cmdId): ${value.toHexString()}");
        final length = value[1];
        if (length > 0) {
          final data = value.sublist(3, value.length - 1);
          completer.complete(data);
        } else {
          completer.complete(null);
        }
        subscription?.cancel();
      }
    });

    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 8), () {
        if (!completer.isCompleted) {
          _logger.warning("send $cmdId timeout");
          completer.complete(null);
          subscription?.cancel();
        }
      })
    ]);

    return completer.future.whenComplete(() => subscription?.cancel());
  }

  Future<List<List<int>>?> _waitMultiRx(int cmdId, int chunkSize) async {
    final completer = Completer<List<List<int>>?>();

    StreamSubscription<List<int>>? subscription;
    List<List<int>> results = List.empty(growable: true);
    subscription = _rxController.stream.listen((value) {
      _logger.info("any value: ${value.toHexString()}");
      if (value[2] == cmdId) {
        _logger.info("value($cmdId): ${value.toHexString()}");
        final length = BytesToInt.convert(value.sublist(3, 5));
        _logger.info("value($cmdId): length = $length");
        if (length > 0) {
          final rawData = value.sublist(3, value.length - 1);
          results.add(rawData);
          var sublist = rawData.sublist(2, rawData.length - 1);
          var lastRawData = ListUtil.splitList(sublist, chunkSize).last;
          _logger.info("value($cmdId): lastRawData = ${lastRawData.toHexString()}");
          final currentIndex = BytesToInt.convert(lastRawData.sublist(0, 2));
          _logger.info("value($cmdId): currentIndex = $currentIndex($length)");
          if (length == currentIndex) {
            completer.complete(results);
          }
        }
      }
    });

    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          _logger.warning("send $cmdId timeout");
          completer.complete(null);
          subscription?.cancel();
        }
      })
    ]);

    return completer.future.whenComplete(() => subscription?.cancel());
  }

  bool _intToBool(int a) => a == 0 ? false : true;

  int _boolToInt(bool a) => a ? 1 : 0;

  // 輸入 List<int>，回傳 Ascii String
  String _fromAscii(List<int> list) {
    String result = "";
    for (var i = 0; i < list.length; i++) {
      result += String.fromCharCode(list[i]);
    }
    return result;
  }

  List<int> _toAscii(String inputString) {
    return inputString.codeUnits;
  }
}

enum CmdId {
  getVersion(0x00),
  getRS485Address(0x01),
  getRS485BaudRate(0x02),
  getTerminatingResistanceSetting(0x03),
  getTemperature(0x04),
  getBarometricPressureSensor(0x05),
  getStrainGauge(0x06),
  getValvePositionSensor(0x07),
  getValveTotalUsed(0x08),
  getOperatingTime(0x09),
  getLedIndicatorState(0x0A),
  getHistoryLog(0x0B),
  getPairingDataHistory(0x0C),
  getDeviceLocation(0x0D),
  getManufacturingDate(0x0E),
  getValvePositionSensorLimit(0x0F),
  getStrainGaugeLimit(0x10),
  getBarometricPressureSensorLimit(0x11),
  getStrainGaugeFormula(0x12), // 先不做，看起來用不到
  getMaintenanceNotificationCount(0x13),
  setRS485Address(0x20),
  setRS485BaudRate(0x21),
  calibrateStrainGauge(0x22),
  setTerminatingResistanceSetting(0x23),
  setValveSwitchCount(0x24),
  setOperatingTime(0x25),
  setLedIndicatorState(0x26),
  setBallValvePairingId(0x27),
  setValvePositionSensorLimit(0x28),
  setStrainGaugeLimit(0x29),
  setBarometricPressureSensorLimit(0x30),
  setCurrentUTC(0x31),
  setDeviceLocation(0x32),
  setManufacturingDate(0x33),
  setStrainGaugeFormula(0x34), // 先不做，看起來用不到
  setMaintenanceNotificationCount(0x35),
  calibrateInductivePositionSensor(0x36),
  ;

  const CmdId(this.id);

  final int id;
}

enum FwCmdId {
  switchToFwMode(0xF0),
  setFwParameter(0xF1),
  sendFwData(0xF2),
  reBoot(0xF3);

  final int id;

  const FwCmdId(this.id);
}

extension ListToHexString on List<int> {
  String toHexString() => map((number) => number.toRadixString(16).padLeft(2, '0')).join(',');
}
