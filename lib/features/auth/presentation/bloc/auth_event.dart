part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignup extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignup({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
  
}
