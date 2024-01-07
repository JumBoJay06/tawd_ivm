part of 'scan_bloc.dart';

@immutable
abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanStarting extends ScanState {
  final bool isScanning;
  ScanStarting(this.isScanning);
}

class ScanSuccess extends ScanState {
  final List<ScanResult> scanResults;

  ScanSuccess(this.scanResults);
}

class ScanFailure extends ScanState {
  final String message;

  ScanFailure(this.message);
}
