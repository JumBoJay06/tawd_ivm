// Language data class , 用 Hive 套件 , 裡面有 String 的 selectLanguage
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Language extends HiveObject {
  Language({required this.selectLanguageCode});

  @HiveField(0)
  int index = 0;

  @HiveField(1)
  String selectLanguageCode;
}