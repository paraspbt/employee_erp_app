import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:emperp_app/features/erp/presentation/usecases/create_employee.dart';
import 'package:emperp_app/features/erp/presentation/usecases/get_employees.dart';
import 'package:emperp_app/features/erp/presentation/usecases/update_employee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'emp_event.dart';
part 'emp_state.dart';

class EmpBloc extends Bloc<EmpEvent, EmpState> {
  final CreateEmployee _createEmployee;
  final GetEmployees _getEmployees;
  final UpdateEmployee _updateEmployee;

  EmpBloc({
    required CreateEmployee createEmployee,
    required GetEmployees getEmployees,
    required UpdateEmployee updateEmployee,
  })  : _createEmployee = createEmployee,
        _getEmployees = getEmployees,
        _updateEmployee = updateEmployee,
        super(EmpInitial()) {
    // Event to handle creating a new employee
    on<CreateEmpEvent>((event, emit) async {
      final currentState = state;
      List<EmployeeModel> currentEmployees = [];
      if (currentState is EmpSuccess) {
        currentEmployees = List<EmployeeModel>.from(currentState.employees);
      }
      emit(EmpLoading());

      final res = await _createEmployee(
        CreateEmployeeParams(
          profileId: event.profileId,
          name: event.name,
          phone: event.phone,
          salary: event.salary,
          joinedAt: event.joinedAt,
          address: event.address,
        ),
      );

      res.fold((l) => emit(EmpFailure(l.message)), (r) {
        currentEmployees.add(r);
        emit(EmpSuccess(currentEmployees));
      });
    });

    // Event to handle retrieving employees
    on<GetEmployeesEvent>((event, emit) async {
      emit(EmpLoading());
      final res = await _getEmployees(event.profileId);
      res.fold((l) => emit(EmpFailure(l.message)), (r) => emit(EmpSuccess(r)));
    });

    // Event to handle updating an employee
    on<UpdateEmpEvent>((event, emit) async {
      final currentState = state;

      if (currentState is! EmpSuccess) {
        emit(EmpFailure("Cannot update employee. Current state is not valid."));
        return;
      }

      List<EmployeeModel> updatedEmployees = List<EmployeeModel>.from(currentState.employees);
      emit(EmpLoading());

      final res = await _updateEmployee(event.updatedEmployee);

      res.fold(
        (failure) => emit(EmpFailure(failure.message)),
        (_) {
          // Replace the old employee with the updated one in the list
          final index = updatedEmployees.indexWhere((e) => e.id == event.updatedEmployee.id);
          if (index != -1) {
            updatedEmployees[index] = event.updatedEmployee;
          }

          emit(EmpSuccess(updatedEmployees));
        },
      );
    });
  }
}
