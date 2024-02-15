part of 'scan_bloc.dart';

@immutable
abstract class ScanEvent {}

class ScanStart extends ScanEvent {
  final int timeout;
  ScanStart(this.timeout);
}

class Failure extends ScanEvent {
  final String message;
  Failure(this.message);
}

class Filter extends ScanEvent {
  final String filter;

  Filter(this.filter);
}

class ScanStop extends ScanEvent {}
