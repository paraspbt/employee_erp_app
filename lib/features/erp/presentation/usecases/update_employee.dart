import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:fpdart/fpdart.dart';

class UpdateEmployee {
  final EmpRemoteDatasource empRemoteDatasource;

  UpdateEmployee(this.empRemoteDatasource);

  Future<Either<Failure, void>> call(EmployeeModel updatedEmployee) async {
    try {
      // Call remote datasource to perform the update
      await empRemoteDatasource.updateEmployee(updatedEmployee);
      return right(null);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
