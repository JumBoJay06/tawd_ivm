part of 'record_chart_cubit.dart';

@immutable
abstract class RecordChartState {}

class RecordChartInitial extends RecordChartState {}

class Loading extends RecordChartInitial {}

class Success extends RecordChartInitial {
  final RecordChart data;

  Success(this.data);
}

class Fail extends RecordChartInitial
{
  final Exception e;

  Fail(this.e);
}