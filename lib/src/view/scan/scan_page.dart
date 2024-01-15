
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ivm_service_device_connect),
      ),
      body: BlocProvider(
        create: (context) => ScanBloc(),
        child: Column(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ScanBloc>().add(ScanStart(
              [IvmManager.getInstance().serviceUuid],
              8
          ));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
