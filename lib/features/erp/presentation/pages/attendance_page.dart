import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/core/widgets/app_button.dart';
import 'package:emperp_app/core/widgets/my_app_bar.dart';
import 'package:emperp_app/core/utils/show_snackbar.dart';
import 'package:emperp_app/features/erp/Attbloc/attendance_bloc.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendancePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AttendancePage());
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final List<EmployeeModel> empList;

  @override
  void initState() {
    empList = (context.read<EmpBloc>().state as EmpSuccess).employees;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceFailure) {
            showSnackbar(context, state.message, true);
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final attendanceMap =
              (state is AttendanceSuccess) ? state.attendanceMap : {};
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text('Attendance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.darkGreen,
                    )),
              ),
              const Divider(
                color: AppPallete.darkGreen,
                indent: 8,
                endIndent: 8,
                thickness: 2,
              ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(8),
                  interactive: true,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: empList.length,
                    itemBuilder: (context, index) {
                      final employee = empList[index];
                      final selectedValue = attendanceMap[employee.id];
                      return Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: AppPallete.faded,
                          width: 2,
                        ))),
                        child: Row(
                          children: [
                            Text(
                              employee.name,
                              style: const TextStyle(
                                color: AppPallete.darkGreen,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            SegmentedButton<String>(
                              emptySelectionAllowed: true,
                              showSelectedIcon: false,
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppPallete.dullGreen.withAlpha(
                                          120); // Your selection color
                                    }
                                    return Colors
                                        .transparent; // Default unselected color
                                  },
                                ),
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    AppPallete.darkGreen),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                side: WidgetStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  color: AppPallete.darkGreen,
                                  width: 1.5,
                                )),
                                padding: WidgetStateProperty.all(
                                    const EdgeInsets.all(8)),
                              ),
                              segments: const [
                                ButtonSegment(
                                  value: 'P',
                                  label: Text('P'),
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.green),
                                ),
                                ButtonSegment(
                                  value: 'A',
                                  label: Text('A'),
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                ),
                              ],
                              selected:
                                  selectedValue == null ? {} : {selectedValue},
                              onSelectionChanged: (selected) {
                                final status =
                                    selected.isEmpty ? null : selected.first;
                                context.read<AttendanceBloc>().add(
                                    MarkAttendanceEvent(employee.id, status));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: AppButton(
                    buttonText: 'Save',
                    onPressed: () {
                      context.read<AttendanceBloc>().add(SyncAttendanceEvent());
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
