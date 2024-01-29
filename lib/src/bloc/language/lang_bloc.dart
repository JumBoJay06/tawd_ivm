import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tawd_ivm/src/data/language.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends Bloc<LangEvent, LangState> {
  LangBloc() : super(const LangInitial(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hand'))) {

    on<GetCurrentLang>((event, emit) async {
      final box = Hive.box<Language>('Language');
      final lang = await box.get(0, defaultValue: Language(selectLanguageCode: 'zh_hant'))!;
      if (lang.selectLanguageCode == "en") {
        emit(const LangEn(Locale('en')));
      } else {
        emit(const LangZhTw(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')));
      }
    });

    on<SettingLangEn>((event, emit) async {
      final box = Hive.box<Language>('Language');
      final lang = await box.get(0, defaultValue: Language(selectLanguageCode: 'zh_hant'))!;
      lang.selectLanguageCode = 'en';
      await box.put(lang.key, lang);
      emit(const LangEn(Locale('en')));
    });

    on<SettingLangZhTW>((event, emit) async {
      final box = Hive.box<Language>('Language');
      final lang = await box.get(0, defaultValue: Language(selectLanguageCode: 'zh_hant'))!;
      lang.selectLanguageCode = 'zh_hant';
      await box.put(lang.key, lang);
      emit(const LangZhTw(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')));
    });
  }
}
