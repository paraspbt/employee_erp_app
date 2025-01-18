import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup {
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);

  Future<Either<Failure, String>> call(UserSignupParams params) async {
    return await authRepository.signupWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String name;
  final String email;
  final String password;

  UserSignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
