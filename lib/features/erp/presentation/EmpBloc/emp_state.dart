part of 'emp_bloc.dart';

@immutable
sealed class EmpState {}

final class EmpInitial extends EmpState {}

final class EmpLoading extends EmpState {}

final class EmpFailure extends EmpState {
  final String message;
  EmpFailure(this.message);
}

final class EmpSuccess extends EmpState {
  final List<EmployeeModel> employees;
  EmpSuccess(this.employees);
}
