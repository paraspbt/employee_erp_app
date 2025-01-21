import 'package:emperp_app/features/erp/presentation/usecases/create_employee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'emp_event.dart';
part 'emp_state.dart';

class EmpBloc extends Bloc<EmpEvent, EmpState> {
  final CreateEmployee createEmployee;
  EmpBloc(this.createEmployee) : super(EmpInitial()) {
    on<EmpEvent>((event, emit) {
      emit(EmpLoading());
    });

    on<CreateEmpEvent>((event, emit) async {
      final res = await createEmployee(
        CreateEmployeeParams(
          profileId: event.profileId,
          name: event.name,
          phone: event.phone,
          salary: event.salary,
          joinedAt: event.joinedAt,
          address: event.address,
        ),
      );

      res.fold((l) => emit(EmpFailure(l.message)), (r) => emit(EmpSuccess()));
    });
  }
}
