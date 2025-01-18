import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emperp_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  const AuthRepositoryImpl(this.authRemoteDatasource);

  @override
  Future<Either<Failure, String>> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await authRemoteDatasource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(userId);
    } catch (e) {
      throw left(Failure(e.toString()));
    }
  }
}
