import 'package:tawd_ivm/src/manager/util/int_to_bytes.dart';

class MaintenanceNotificationCount {
  final MaintenanceType type;
  final int maintenanceCountLimit;
  final int maintenanceAccumulatedCount;

  MaintenanceNotificationCount(this.type, this.maintenanceCountLimit, this.maintenanceAccumulatedCount);

  List<int> toList() {
    return List.empty(growable: true)
        ..add(type.toInt())
        ..addAll(IntToBytes.convertToIntList(maintenanceCountLimit, 4))
    ..addAll(IntToBytes.convertToIntList(maintenanceAccumulatedCount, 4));
  }
}

enum MaintenanceType {
  cycle, limit;

  static MaintenanceType fromInt(int value) {
    return value == 0 ? MaintenanceType.cycle : MaintenanceType.limit;
  }

  int toInt() {
    switch (this) {
      case cycle:
        return 0;
      case limit:
        return 1;
    }
  }
}