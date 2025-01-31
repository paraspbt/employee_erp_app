part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceSuccess extends AttendanceState {
  final Map<String, String?> attendanceMap;
  AttendanceSuccess({required this.attendanceMap});
}

final class AttendanceFailure extends AttendanceState {
  final String message;
  AttendanceFailure(this.message);
}

final class AttendanceLoading extends AttendanceState {}