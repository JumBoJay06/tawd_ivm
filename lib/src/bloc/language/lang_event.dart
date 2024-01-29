part of 'lang_bloc.dart';

@immutable
abstract class LangEvent {}

class GetCurrentLang extends LangEvent {}

class SettingLangZhTW extends LangEvent {}

class SettingLangEn extends LangEvent {}
