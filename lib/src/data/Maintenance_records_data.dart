import 'about_device_data.dart';

class MaintenanceRecords {
  final List<Item> ivmInfo;
  final List<Item> currentValve;
  final List<PairingLog> pairingLogList;

  MaintenanceRecords(this.ivmInfo, this.currentValve, this.pairingLogList);
}

class PairingLog {
  final String date;
  final String ivmId;
  final int totalUsed;

  PairingLog(this.date, this.ivmId, this.totalUsed);
}