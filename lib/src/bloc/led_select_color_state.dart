part of 'led_select_color_cubit.dart';

@immutable
abstract class LedSelectColorState {}

class LedSelectColorInitial extends LedSelectColorState {}

class OnChange extends LedSelectColorInitial {
  final int selectIndex;

  OnChange(this.selectIndex);
}