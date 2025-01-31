import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAttendance {
  final EmpRemoteDatasource empRemoteDatasource;
  UpdateAttendance(this.empRemoteDatasource);
  Future<Either<Failure, void>> call(
      List<MapEntry<String, String?>> validEntries) async {
    try {
      await empRemoteDatasource.updateAttendance(validEntries);
      print('tag usecase $validEntries');
      return right(null);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
