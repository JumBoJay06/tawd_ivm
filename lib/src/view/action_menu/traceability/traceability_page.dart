import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawd_ivm/route.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../bloc/traceability/traceability_cubit.dart';

class TraceabilityPage extends StatefulWidget {
  const TraceabilityPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return Traceability();
  }
}

class Traceability extends State<TraceabilityPage> {
  TraceabilityCubit traceabilityCubit = TraceabilityCubit();
  final WebViewController _webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    traceabilityCubit.checkValveId();
  }

  @override
  void dispose() {
    traceabilityCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: traceabilityCubit,
      listener: (context, state) {
        if (state is HadValveId) {
          _webViewController.loadRequest(Uri.parse("https://www.tawdvalve.com/traceability/serial/keyword/${state.id}"));
        } else {
          Navigator.popAndPushNamed(context, kRouteReplaceBallValvePage);
        }
      },
      child: WebViewWidget(controller: _webViewController),
    );
  }
}
