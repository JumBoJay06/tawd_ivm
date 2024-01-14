// class PairedDevice extends HiveObject ,裡面有 int id, String name
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class PairedDevice extends HiveObject {
  PairedDevice({required this.id, required this.name});

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;
}