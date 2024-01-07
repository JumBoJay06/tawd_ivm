import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_cmd_bloc.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_connection_bloc.dart';
import 'package:tawd_ivm/src/bloc/ivm/scan/scan_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config.dart';
import 'src/manager/ivm_manager.dart';


void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScanBloc>(
          create: (context) => ScanBloc(),
        ),
        BlocProvider<IvmConnectionBloc>(
          create: (context) => IvmConnectionBloc(),
        ),
        BlocProvider<IvmCmdBloc>(
          create: (context) => IvmCmdBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const _ScanPage(),
      ),
    );
  }
}

// 產生掃描畫面，依據 scan_bloc.dart 的 ScanEvent 來決定掃描的開始與結束，有一個scan按鈕觸發掃描，並將 ScanSuccess 的結果顯示出來
class _ScanPage extends StatelessWidget {
  const _ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
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
