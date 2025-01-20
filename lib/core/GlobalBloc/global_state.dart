part of 'global_bloc.dart';

@immutable
sealed class GlobalState {}

final class GlobalInitial extends GlobalState {}

final class AppUserLoggedIn extends GlobalState {
  final UserModel userModel;
  AppUserLoggedIn(this.userModel);
}
