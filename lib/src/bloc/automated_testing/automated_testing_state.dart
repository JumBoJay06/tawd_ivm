part of 'automated_testing_cubit.dart';

@immutable
abstract class AutomatedTestingState {}

class AutomatedTestingInitial extends AutomatedTestingState {}

class Loading extends AutomatedTestingState{
  final AutomatedTestingResult result;

  Loading(this.result);
}

class Done extends AutomatedTestingState{
  final AutomatedTestingResult result;

  Done(this.result);
}