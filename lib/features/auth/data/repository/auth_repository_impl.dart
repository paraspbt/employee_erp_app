// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';

import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/core/network/connection_check.dart';
import 'package:emperp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emperp_app/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl {
  final AuthRemoteDatasource authRemoteDatasource;
  final ConnectionCheck connectionCheck;
  const AuthRepositoryImpl(
    this.authRemoteDatasource,
    this.connectionCheck,
  );

  Future<Either<Failure, UserModel>> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      if (!await (connectionCheck.isConnected)) {
        return left(Failure('No Internet'));
      }
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
      if (!await (connectionCheck.isConnected)) {
        return left(Failure('No Internet'));
      }
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

  Future<Either<Failure, UserModel>> currentUser() async {
    try {
      if (!await (connectionCheck.isConnected)) {
        final session = authRemoteDatasource.currentSesion;

        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final userModel = await authRemoteDatasource.getCurrentUserData();
      if (userModel == null) {
        return left(Failure('User not logged in!'));
      }
      return right(userModel);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
