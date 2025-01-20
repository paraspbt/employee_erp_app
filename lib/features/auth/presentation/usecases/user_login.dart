import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin {
  final AuthRepositoryImpl authRepositoryImpl;
  UserLogin(this.authRepositoryImpl);
  Future<Either<Failure, UserModel>> call(UserLoginParams params) async {
    final res = await authRepositoryImpl.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
    return res;
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
