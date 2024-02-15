part of 'ivm_maintenance_records_cubit.dart';

@immutable
abstract class IvmMaintenanceRecordsState {}

class IvmMaintenanceRecordsInitial extends IvmMaintenanceRecordsState {}

class Loading extends IvmMaintenanceRecordsInitial {}

class Success extends IvmMaintenanceRecordsInitial {
  final MaintenanceRecords data;

  Success(this.data);
}

class Fail extends IvmMaintenanceRecordsInitial {
  final Exception e;

  Fail(this.e);
}