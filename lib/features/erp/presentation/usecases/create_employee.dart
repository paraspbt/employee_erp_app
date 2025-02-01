// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:emperp_app/core/errors/failure.dart';
import 'package:emperp_app/core/network/connection_check.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';

class CreateEmployee {
  final EmpRemoteDatasource empRemoteDatasource;
  final ConnectionCheck connectionCheck;
  CreateEmployee(
    this.empRemoteDatasource,
    this.connectionCheck,
  );
  Future<Either<Failure, EmployeeModel>> call(
      CreateEmployeeParams params) async {
    try {
      if (!await (connectionCheck.isConnected)) {
        return left(Failure('No Internet'));
      }
      EmployeeModel employeeModel = EmployeeModel(
        id: const Uuid().v1(),
        profileId: params.profileId,
        name: params.name,
        phone: params.phone,
        salary: params.salary,
        joinedAt: params.joinedAt,
        updatedAt: DateTime.now(),
        address: params.address,
      );
      final res = await empRemoteDatasource.createEmployee(employeeModel);
      return right(res);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

class CreateEmployeeParams {
  final String profileId;
  final String name;
  final String phone;
  final double salary;
  final String joinedAt;
  final String? address;

  CreateEmployeeParams({
    required this.profileId,
    required this.name,
    required this.phone,
    required this.salary,
    required this.joinedAt,
    required this.address,
  });
}
