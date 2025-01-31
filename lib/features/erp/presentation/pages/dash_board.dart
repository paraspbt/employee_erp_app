import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/core/utils/valid_attendance.dart';
import 'package:emperp_app/features/erp/Attbloc/attendance_bloc.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/pages/attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmpBloc, EmpState>(
      // Listen to EmpBloc for employee data
      builder: (context, empState) {
        if (empState is EmpLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (empState is EmpFailure) {
          return const Center(child: Text('Error loading employees.'));
        }
        if (empState is EmpSuccess) {
          final employees = empState.employees;

          // Calculate the total credits and total salary
          final totals = calculateTotals(employees);
          final totalCredit = totals['totalCredit'] ?? 0.0;
          final totalSalary = totals['totalSalary'] ?? 0.0;

          // Calculate the progress as the ratio of totalCredit/totalSalary
          final double progress1 =
              totalSalary == 0 ? 0 : totalCredit / totalSalary;

          return BlocBuilder<AttendanceBloc, AttendanceState>(
            // Listen to AttendanceBloc for attendance data
            builder: (context, attendanceState) {
              final Map<String, String?> attendanceMap =
                  (attendanceState is AttendanceSuccess)
                      ? attendanceState.attendanceMap
                      : {};
              final totalEmployee = employees.length;
              final totalPresent = validAttendance(attendanceMap).length;
              final double progress2 =
                  totalEmployee == 0 ? 0 : totalPresent / totalEmployee;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Title for the summary section
                    const Text('Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.darkGreen,
                        )),
                    const Divider(
                      color: AppPallete.darkGreen,
                      thickness: 2,
                    ),
                    _buildSummaryCard(
                      title: 'Attendance',
                      content: [
                        'Present: $totalPresent',
                        'Total Employees: $totalEmployee',
                      ],
                      progress: progress2,
                      progressColor: AppPallete.darkGreen,
                      backgroundColor: AppPallete.backgroundColor,
                    ),
                    const Divider(
                      color: AppPallete.faded,
                      thickness: 2,
                    ),
                    _buildSummaryCard(
                      title: 'Accounts',
                      content: [
                        'Credit: ${totalCredit.toInt()}',
                        'Salary: ${totalSalary.toInt()}',
                      ],
                      progress: progress1,
                      progressColor: AppPallete.brightRed,
                      backgroundColor: AppPallete.backgroundColor,
                    ),
                    const Divider(
                      color: AppPallete.faded,
                      thickness: 2,
                    ),
                    const Spacer(),
                    FloatingActionButton.extended(
                      label: const Text(
                        'Attendance',
                        style: TextStyle(
                            color: AppPallete.darkGreen, fontSize: 20),
                      ),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        side: BorderSide(
                          color: AppPallete.darkGreen,
                          width: 4,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppPallete.darkGreen,
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(context, AttendancePage.route());
                      },
                      heroTag: 'Attendance Route',
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // Function to build the summary card with progress indicator
  Widget _buildSummaryCard({
    required String title,
    required List<String> content,
    required double progress,
    required Color progressColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 6,
        //     offset: const Offset(0, 2),
        //   ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of the section
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppPallete.darkGreen,
            ),
          ),
          const SizedBox(height: 8),

          // Display content text
          ...content.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line,
                style: const TextStyle(
                  color: AppPallete.darkGreen,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Linear progress bar
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: progressColor, width: 1),
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: progressColor,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  // Function to calculate total credit and total salary
  Map<String, double> calculateTotals(List<EmployeeModel> employees) {
    double totalCredit = 0.0;
    double totalSalary = 0.0;

    for (var employee in employees) {
      totalCredit += employee.credit;
      totalSalary += employee.salary;
    }

    return {
      'totalCredit': totalCredit,
      'totalSalary': totalSalary,
    };
  }
}
