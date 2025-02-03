import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class LogOut {
  final AuthRepositoryImpl authRepositoryImpl;
  LogOut(this.authRepositoryImpl);
  Future<Either<Failure, void>> call() async {
    final res = await authRepositoryImpl.logout();
    return res;
  }
}
