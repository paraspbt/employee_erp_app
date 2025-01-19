import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup {
  final AuthRepositoryImpl authRepositoryImpl;
  const UserSignup(this.authRepositoryImpl);

  Future<Either<Failure, UserModel>> call(UserSignupParams params) async {
    final res = await authRepositoryImpl.signupWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
    return res;
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
