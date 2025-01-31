import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:fpdart/fpdart.dart';

class GetEmployees {
  final EmpRemoteDatasource empRemoteDatasource;
  GetEmployees(this.empRemoteDatasource);
  Future<Either<Failure, List<EmployeeModel>>> call(String profileId) async {
    try {
      final res = await empRemoteDatasource.getEmployees(profileId);
      return right(res);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
