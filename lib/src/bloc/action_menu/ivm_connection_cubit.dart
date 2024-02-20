import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/manager/ivm_manager.dart';

part 'ivm_connection_state.dart';

class IvmConnectionCubit extends Cubit<IvmConnectionState> {
  IvmConnectionCubit() : super(IvmConnectionInitial());

  int reconnectCount = 0;

  void observeIvmConnectState() async {
    var device = IvmManager.getInstance().device;
    device?.connectionState.listen((event) async {
      switch (event) {
        case BluetoothConnectionState.disconnected:
          if (reconnectCount == 4) {
            emit(Disconnected());
          } else {
            reconnectCount++;
            IvmManager.getInstance().connect(device);
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
