import 'package:emperp_app/core/utils/valid_attendance.dart';
import 'package:emperp_app/features/erp/presentation/usecases/update_attendance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final UpdateAttendance _updateAttendance;
  AttendanceBloc({required UpdateAttendance updateAttendance})
      : _updateAttendance = updateAttendance,
        super(AttendanceInitial()) {
    on<MarkAttendanceEvent>((event, emit) {
      final currentAttendanceMap = state is AttendanceSuccess
          ? (state as AttendanceSuccess).attendanceMap
          : {};

      final updatedAttendanceMap =
          Map<String, String?>.from(currentAttendanceMap)
            ..[event.employeeId] = event.attendanceStatus;

      emit(AttendanceSuccess(attendanceMap: updatedAttendanceMap));
    });

    on<SyncAttendanceEvent>((event, emit) async {
      if (state is AttendanceSuccess) {
        final currentState = state as AttendanceSuccess;
        final validEntries = validAttendance(currentState.attendanceMap);
        emit(AttendanceLoading());
        final res = await _updateAttendance.call(validEntries);
        res.fold((l) {
          emit(AttendanceFailure(l.message));
        }, (r) {
          emit(AttendanceSuccess(attendanceMap: currentState.attendanceMap));
        });
      }
    });
  }
}
