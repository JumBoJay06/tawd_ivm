part of 'scan_bloc.dart';

@immutable
abstract class ScanEvent {}

class ScanStart extends ScanEvent {
  final List<Guid> serviceUuids;
  final int timeout;
  ScanStart(this.serviceUuids, this.timeout);
}

class Success extends ScanEvent {
  final List<ScanResult> scanResults;
  Success(this.scanResults);
}

class Failure extends ScanEvent {
  final String message;
  Failure(this.message);
}

class ScanStop extends ScanEvent {}
