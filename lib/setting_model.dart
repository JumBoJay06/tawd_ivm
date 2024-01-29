import 'package:flutter/widgets.dart';

class SettingModel extends ChangeNotifier {
  Locale _locale = Locale(const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant').languageCode);

  Locale get locale => _locale;

  changeLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}