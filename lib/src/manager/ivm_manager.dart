import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';

class IvmManager {
  static final IvmManager _instance = IvmManager._();

  static IvmManager getInstance() => _instance;

  IvmManager._() {
    FlutterBluePlus.scanResults.listen((event) {
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

  final StreamController<List<ScanResult>> _scanController =
      StreamController<List<ScanResult>>.broadcast();

  Stream<List<ScanResult>> get scanStream => _scanController.stream;

  final StreamController<List<int>> _rxController =
      StreamController<List<int>>.broadcast();

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
        _logger.warning("not found $name");
        completer.complete(null);
      })
    ]);

    return completer.future.whenComplete(() => subscription?.cancel());
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

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
                _rxController.sink.add(value);
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
      await _device!.disconnect();
      await _rxController.close();
    }
  }

  // 指令都會以下面方式實作，搭配IvmCmdBloc使用
  Future<String?> getVersion() async {
    try {
      final send = _createCmd(CmdId.getVersion.id);
      final list = await _write(send);
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

  Future<String?> getRS485Address() async {
    try {
      final send = _createCmd(CmdId.getRS485Address.id);
      final list = await _write(send);
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

  List<int> _createCmd(int cmdId, {List<int>? data}) {
    final length = (data?.length ?? 0) + 2;
    final send = [0x25, length, cmdId];
    if (data != null) {
      send.addAll(data);
    }
    send.add(_xor(send));
    return send;
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
      _logger.info("write(${send[2]}) -> $send");
      _writeCharacteristic!.write(send);
      _logger.info("write(${send[2]}) -> done");
      return await _waitRx(send[2]);
    } catch (e) {
      return null;
    }
  }

  Future<List<int>?> _waitRx(int cmdId) async {
    final completer = Completer<List<int>?>();

    StreamSubscription<List<int>>? subscription;
    subscription = _rxController.stream.listen((value) {
      _logger.info("any value: $value");
      if (value[2] == cmdId) {
        _logger.info("value($cmdId): $value");
        completer.complete(value);
        subscription?.cancel();
      }
    });

    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 8), () {
        _logger.warning("send $cmdId timeout");
        completer.complete(null);
      })
    ]);

    return completer.future.whenComplete(() => subscription?.cancel());
  }
}

enum CmdId {
  getVersion(id: 0x00),
  getRS485Address(id: 0x01);

  const CmdId({required this.id});

  final int id;
}
