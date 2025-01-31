part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class CurrNavState extends NavigationState {
  final int index;
  CurrNavState(this.index);
}