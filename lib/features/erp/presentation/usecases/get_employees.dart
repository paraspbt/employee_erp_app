// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';

import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/core/network/connection_check.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_local_datasource.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';

class GetEmployees {
  final EmpRemoteDatasource empRemoteDatasource;
  final EmpLocalDatasource empLocalDatasource;
  final ConnectionCheck connectionCheck;
  GetEmployees(
    this.empRemoteDatasource,
    this.empLocalDatasource,
    this.connectionCheck,
  );
  Future<Either<Failure, List<EmployeeModel>>> call(String profileId) async {
    try {
      if (!await (connectionCheck.isConnected)) {
        final employees = empLocalDatasource.loadEmployees();
        return right(employees);
      }
      final res = await empRemoteDatasource.getEmployees(profileId);
      empLocalDatasource.uploadEmployees(res);
      return right(res);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
