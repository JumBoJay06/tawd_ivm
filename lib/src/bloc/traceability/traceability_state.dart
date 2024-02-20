part of 'traceability_cubit.dart';

@immutable
abstract class TraceabilityState {}

class TraceabilityInitial extends TraceabilityState {}

class HadValveId extends TraceabilityState {
  final String id;

  HadValveId(this.id);
}

class WithoutValveId extends TraceabilityState {}