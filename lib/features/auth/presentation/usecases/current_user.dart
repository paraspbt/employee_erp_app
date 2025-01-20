import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser {
  final AuthRepositoryImpl authRepositoryImpl;
  CurrentUser(this.authRepositoryImpl);
  Future<Either<Failure, UserModel>> call() async {
    return await authRepositoryImpl.currentUser();
  }
}
