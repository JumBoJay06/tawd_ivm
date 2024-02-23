import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'ivm_connection_state.dart';

class IvmConnectionCubit extends Cubit<IvmConnectionState> {
  IvmConnectionCubit() : super(IvmConnectionInitial());

  int reconnectCount = 0;

  void observeIvmConnectState() async {
    var manager = IvmManager.getInstance();
    var device = manager.device;
    device?.connectionState.listen((event) async {
      if (isClosed || manager.isReboot) {
        return;
      }
      switch (event) {
        case BluetoothConnectionState.disconnected:
          if (reconnectCount == 2) {
            emit(Disconnected());
          } else {
            final bluetoothAdapterState = FlutterBluePlus.adapterStateNow;
            if (bluetoothAdapterState != BluetoothAdapterState.on) {
              emit(BleOff());
            } else {
              if (reconnectCount > 0) {
                await Future.delayed(const Duration(seconds: 2), () {});
              }
              emit(Connecting());
              reconnectCount++;
              manager.connect(device, timeout: const Duration(seconds: 4)).then((value) async {
                if (!value) {
                  final bluetoothAdapterState = await FlutterBluePlus.adapterState.first;
                  if (bluetoothAdapterState != BluetoothAdapterState.on) {
                    emit(BleOff());
                  }
                }
              });
            }
          }
          break;
        case BluetoothConnectionState.connected:
          reconnectCount = 0;
          emit(Connected());
          break;
        default:
          break;
      }
    });
  }
}
