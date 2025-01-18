import 'package:emperp_app/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
