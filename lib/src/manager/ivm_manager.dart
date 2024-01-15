import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/main.dart';

class IvmManager {
  static final IvmManager _instance = IvmManager._();
  static IvmManager getInstance() => _instance;
  IvmManager._();

  final Guid serviceUuid = Guid("7e400001-b5a3-f393-e0a9-e50e24dcca9e");
  final Guid _writeUuid = Guid("7e400002-b5a3-f393-e0a9-e50e24dcca9e");
  final Guid _notifyUuid = Guid("7e400003-b5a3-f393-e0a9-e50e24dcca9e");

  BluetoothDevice? _device;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;

  BluetoothDevice? get device => _device;

  Logger get _logger => Logger("IvmManager");

  Future<bool> connect(BluetoothDevice device) async {
    _device = device;

    await device.connect(timeout: const Duration(seconds: 8));

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
              characteristic.onValueReceived.listen((value) {
                _logger.fine("rx: $value");
              });
              _logger.info("Discover notify characteristic");
            }
          }
        }
      }
      if (_writeCharacteristic != null && _notifyCharacteristic != null) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<void> disconnect() async {
    if (_device != null) {
      _device!.disconnect();
    }
  }

  // 指令都會以下面方式實作，搭配IvmCmdBloc使用
  Future<String?> getVersion() async {
    try {
      final send = [0x25, 0x00, 0x00];
      send.add(_xor(send));
      final list =  await _write(send);
      if (list != null) {
        return _ascii(list.sublist(3, list.length - 1));
      } else {
        return null;
      }
    } catch (e) {
      Future.error(e);
    }
    return null;
  }

  // 輸入 List<int> ，依序做xor，最後回傳int
  int _xor(List<int> list) {
    int result = 0;
    for (var i = 0; i < list.length; i++) {
      result ^= list[i];
    }
    return result;
  }

  // 輸入 List<int>，回傳 Ascii String
  String _ascii(List<int> list) {
    String result = "";
    for (var i = 0; i < list.length; i++) {
      result += String.fromCharCode(list[i]);
    }
    return result;
  }

  Future<List<int>?> _write(List<int> send) async {
    try {
      if (_writeCharacteristic == null || _notifyCharacteristic == null) {
        throw Exception("No write characteristic");
      }
      _logger.info("write -> $send");
      await _writeCharacteristic!.write(send);
      List<int>? result;
      
      await Future.delayed(const Duration(seconds: 8), () {
        _notifyCharacteristic!.onValueReceived.listen((value) {
          _logger.info("any value: $value");
          if (value[2] == send[2]) {
            _logger.info("value: $value");
            result = value;
          }
        });
      });
      
      return result;
    } catch (e) {
      return null;
    }
  }
}