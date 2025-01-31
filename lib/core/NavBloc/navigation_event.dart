part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

class NavChangeEvent extends NavigationEvent {
  final int index;
  NavChangeEvent(this.index);
}
