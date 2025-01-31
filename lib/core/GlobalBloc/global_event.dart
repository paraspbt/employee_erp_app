part of 'global_bloc.dart';

@immutable
sealed class GlobalEvent {}

class UpdateUser extends GlobalEvent {
  final UserModel? userModel;
  UpdateUser(this.userModel);
}

class SetDate extends GlobalEvent {
  final String currDate;
  SetDate(this.currDate);
}
