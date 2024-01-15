
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../generated/l10n.dart';
import '../../bloc/ivm/manager/ivm_cmd_bloc.dart';
import '../../bloc/ivm/manager/ivm_connection_bloc.dart';
import '../../bloc/ivm/scan/scan_bloc.dart';
import '../../manager/ivm_manager.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScanPage();
  }
}

class _ScanPage extends StatelessWidget {
  const _ScanPage({super.key});
  Logger get _logger => Logger("ScanPage");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ivm_service_device_connect),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ScanBloc, ScanState>(
              builder: (context, state) {
                if (state is ScanSuccess) {
                  return ListView.builder(
                    itemCount: state.scanResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.scanResults[index].device.platformName),
                        subtitle: Text(state.scanResults[index].device.remoteId.toString()),
                        onTap: () {
                          context.read<IvmConnectionBloc>().add(
                              IvmConnect(state.scanResults[index].device));
                        },
                      );
                    },
                  );
                } else if (state is ScanStarting) {
                  return const Center(
                    child: Text('Scanning...'),
                  );
                } else {
                  return const Center(
                    child: Text('Press Scan Button'),
                  );
                }
              },
            ),
          ),
          Expanded(
              child: BlocBuilder<IvmConnectionBloc, IvmConnectionState>(
                  builder: (context, state) {
                    if (state is IvmConnectionStateChange) {
                      switch (state.state) {
                        case IvmConnectionStatus.connecting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case IvmConnectionStatus.connected:
                          context.read<IvmCmdBloc>().add(CmdGetVersion());
                          return const Center(
                            child: Text('Connected'),
                          );
                        case IvmConnectionStatus.disconnected:
                          return const Center(
                            child: Text('Disconnected'),
                          );
                        default:
                          return const Center(
                            child: Text('Init'),
                          );
                      }
                    } else {
                      return const Center(
                        child: Text('Nan'),
                      );
                    }
                  }
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => const RequestPermissions().myAsyncMethod(context),
        child: const Text('Scan'),
      ),
    );
  }


}

class RequestPermissions {
  const RequestPermissions();

  Logger get _logger => Logger("RequestPermissions");

  Future<void> myAsyncMethod(BuildContext context) async {
    final isGranted = await _requestBlePermissions();
    if(!isGranted) {
      return;
    }
    context.read<ScanBloc>().add(ScanStart(
        [IvmManager.getInstance().serviceUuid],
        8
    ));
  }

  Future<bool> _requestBlePermissions() async {
    var isLocationGranted = await Permission.locationWhenInUse.request();
    _logger.info('checkBlePermissions, isLocationGranted=$isLocationGranted');

    var isBleGranted = await Permission.bluetooth.request();
    _logger.info('checkBlePermissions, isBleGranted=$isBleGranted');

    var isBleScanGranted = await Permission.bluetoothScan.request();
    _logger.info('checkBlePermissions, isBleScanGranted=$isBleScanGranted');
    //
    var isBleConnectGranted = await Permission.bluetoothConnect.request();
    _logger.info('checkBlePermissions, isBleConnectGranted=$isBleConnectGranted');
    //
    var isBleAdvertiseGranted = await Permission.bluetoothAdvertise.request();
    _logger.info('checkBlePermissions, isBleAdvertiseGranted=$isBleAdvertiseGranted');

    if(Platform.isIOS) {
      return isBleGranted == PermissionStatus.granted;
    }else {
      return isLocationGranted == PermissionStatus.granted &&
          // isBleGranted == PermissionStatus.granted  &&
          isBleScanGranted == PermissionStatus.granted &&
          isBleConnectGranted == PermissionStatus.granted &&
          isBleAdvertiseGranted == PermissionStatus.granted;
    }
  }
}
