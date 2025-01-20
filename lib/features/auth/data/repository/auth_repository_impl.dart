import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl {
  final AuthRemoteDatasource authRemoteDatasource;
  const AuthRepositoryImpl(this.authRemoteDatasource);

  Future<Either<Failure, UserModel>> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final userModel = await authRemoteDatasource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(userModel);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await authRemoteDatasource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(userModel);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
