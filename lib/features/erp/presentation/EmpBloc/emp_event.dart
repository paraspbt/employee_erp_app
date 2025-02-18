part of 'emp_bloc.dart';

@immutable
sealed class EmpEvent {}

final class CreateEmpEvent extends EmpEvent {
  final String profileId;
  final String name;
  final String phone;
  final double salary;
  final String joinedAt;
  final String? address;

  CreateEmpEvent({
    required this.profileId,
    required this.name,
    required this.phone,
    required this.salary,
    required this.joinedAt,
    required this.address,
  });
}

final class GetEmployeesEvent extends EmpEvent {
  final String profileId;
  GetEmployeesEvent({
    required this.profileId,
  });
}

final class UpdateEmpEvent extends EmpEvent {
  final EmployeeModel updatedEmployee;
  UpdateEmpEvent({
    required this.updatedEmployee,
  });
}
