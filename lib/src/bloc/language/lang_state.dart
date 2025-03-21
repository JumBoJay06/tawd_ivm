part of 'lang_bloc.dart';

@immutable
abstract class LangState {
  final Locale locale;

  const LangState(this.locale);
}

class LangInitial extends LangState {
  const LangInitial(super.locale);
}

class LangZhTw extends LangState {
  const LangZhTw(super.locale);
}

class LangEn extends LangState {
  const LangEn(super.locale);
}

class LangDa extends LangState {
  const LangDa(super.locale);
}

class LangSv extends LangState {
  const LangSv(super.locale);
}

class LangDe extends LangState {
  const LangDe(super.locale);
}
