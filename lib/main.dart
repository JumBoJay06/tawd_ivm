import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:tawd_ivm/src/bloc/device_text_field/device_text_field_bloc.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_cmd_bloc.dart';
import 'package:tawd_ivm/src/bloc/ivm/manager/ivm_connection_bloc.dart';
import 'package:tawd_ivm/src/bloc/ivm/scan/scan_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawd_ivm/route.dart';
import 'package:tawd_ivm/src/bloc/language/lang_bloc.dart';
import 'package:tawd_ivm/src/bloc/paired_device/paired_device_bloc.dart';
import 'package:tawd_ivm/src/data/language.dart';
import 'package:tawd_ivm/src/data/paired_device.dart';
import 'package:tawd_ivm/src/data/shared_preferences/my_shared_preferences.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  await ScreenUtil.ensureScreenSize();
  await MySharedPreferences.getInstance().init();
  await Hive.initFlutter();
  Hive.registerAdapter(LanguageAdapter());
  Hive.registerAdapter(PairedDeviceAdapter());
  await Hive.openBox<Language>('Language');
  await Hive.openBox<PairedDevice>('PairedDevice');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<LangBloc>(
        create: (context) => LangBloc(),
      ),
      BlocProvider<ScanBloc>(
        create: (context) => ScanBloc(),
      ),
      BlocProvider<IvmCmdBloc>(
        create: (context) => IvmCmdBloc(),
      ),
      BlocProvider<DeviceTextFieldBloc>(
        create: (context) => DeviceTextFieldBloc(),
      ),
      BlocProvider<PairedDeviceBloc>(
        create: (context) => PairedDeviceBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    context.read<LangBloc>().add(GetCurrentLang());
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, state) {
        return MaterialApp(
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          supportedLocales: const [
            // 預設語系為繁體中文
            Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
            Locale('en'),
            Locale('da'),
            Locale('sv'),
            Locale('de'),
          ],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: state.locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          onGenerateRoute: onRoute,
          initialRoute: kRouteAds,
        );
      },
    );
  }
}
