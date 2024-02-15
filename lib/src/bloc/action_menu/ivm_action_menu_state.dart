part of 'ivm_action_menu_cubit.dart';

@immutable
abstract class IvmActionMenuState {}

class IvmActionMenuInitial extends IvmActionMenuState {}

class Loading extends IvmActionMenuInitial {}

class Success extends IvmActionMenuInitial {
  final String name;
  final String location;

  Success(this.name, this.location);
}

class Fail extends IvmActionMenuInitial {
  final Exception e;

  Fail(this.e);
}