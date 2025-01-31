part of 'global_bloc.dart';

@immutable
sealed class GlobalState {}

final class GlobalInitial extends GlobalState {}

final class AppInState extends GlobalState {
  final String currDate;
  final UserModel userModel;
  AppInState(this.userModel, this.currDate,);
  
}
