part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class MarkAttendanceEvent extends AttendanceEvent {
  final String employeeId;
  final String? attendanceStatus;
  MarkAttendanceEvent(this.employeeId, this.attendanceStatus);
}

class SyncAttendanceEvent extends AttendanceEvent{}