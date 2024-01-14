// Language data class , 用 Hive 套件 , 裡面有 String 的 selectLanguage
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Language extends HiveObject {
  Language({required this.selectLanguage});

  @HiveField(0)
  String selectLanguage;
}