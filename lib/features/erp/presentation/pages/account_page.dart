// ignore_for_file: use_build_context_synchronously

import 'package:dotted_line/dotted_line.dart';
import 'package:emperp_app/core/widgets/app_button.dart';
import 'package:emperp_app/core/widgets/input_field.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/pages/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/core/widgets/my_app_bar.dart';
import 'package:emperp_app/core/utils/show_snackbar.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:emperp_app/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  final EmployeeModel employee;

  static route({required EmployeeModel employee}) => MaterialPageRoute(
        builder: (context) => AccountPage(
          employee: employee,
        ),
      );

  const AccountPage({super.key, required this.employee});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final empRemoteDatasource = getIt<EmpRemoteDatasource>();
  List<MapEntry<String, bool>> attendance = [];
  int presentCount = 0;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      attendance =
          await empRemoteDatasource.fetchAttendance(widget.employee.id);
      presentCount = attendance.where((entry) => entry.value).length;

      hasError = false;
    } catch (e) {
      hasError = true;
      showSnackbar(context, 'Error: ${e.toString()}', true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAbsentDaysModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPallete.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.7,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: attendance.length,
              itemBuilder: (context, index) {
                final entry = attendance[index];
                return ListTile(
                  leading: Icon(
                    entry.value ? Icons.check_circle : Icons.cancel,
                    color: entry.value
                        ? AppPallete.brightGreen
                        : AppPallete.brightRed,
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                        fontSize: 16, color: AppPallete.darkGreen),
                  ),
                  subtitle: Text(
                    entry.value ? 'Present' : 'Absent',
                    style: TextStyle(
                      color: entry.value
                          ? AppPallete.brightGreen
                          : AppPallete.brightRed,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;

    return Scaffold(
      appBar: MyAppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppPallete.darkGreen,
            ),
            color: AppPallete.backgroundColor,
            onSelected: (String result) {
              if (result == 'edit') {
                Navigator.push(context, EditPage.route(employee: employee));
              } else if (result == 'delete') {
                _deleteAlert(widget.employee.id);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text(
                  'Edit',
                  style: TextStyle(color: AppPallete.darkGreen),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppPallete.darkGreen,
              ),
            )
          : hasError
              ? const Center(
                  child: Text(
                    'Failed to load attendance. Please try again.',
                    style: TextStyle(color: AppPallete.brightRed),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      _buildHeader(employee.name),
                      const Divider(color: AppPallete.darkGreen, thickness: 2),
                      _buildInfoRow('Last Paid:', employee.lastPaid),
                      _buildInfoRow('Phone:', employee.phone),
                      const Divider(color: AppPallete.darkGreen, thickness: 2),
                      accountRow('Salary:', employee.salary.toInt().toString(),
                          AppPallete.brightGreen),
                      accountRow(
                        'Adjusted Salary:',
                        adjustedSalary(employee.salary, presentCount)
                            .toString(),
                        AppPallete.brightGreen,
                      ),
                      accountRow(
                        'Credit:',
                        employee.credit.toInt().toString(),
                        AppPallete.brightRed,
                      ),
                      const DottedLine(
                        direction: Axis.horizontal,
                        dashColor: AppPallete.darkGreen,
                      ),
                      accountRow(
                        'Net Payable:',
                        (adjustedSalary(employee.salary, presentCount) -
                                employee.credit)
                            .toStringAsFixed(0),
                        AppPallete.brightGreen,
                      ),
                      const DottedLine(
                        direction: Axis.horizontal,
                        dashColor: AppPallete.darkGreen,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Presents:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppPallete.darkGreen,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showAbsentDaysModal(context);
                                  },
                                  child: const Text(
                                    'View Attendance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppPallete.dullGreen,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              presentCount.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppPallete.darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                          buttonText: 'Add Credit Note',
                          onPressed: () => _addCreditNote(context)),
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                          buttonText: 'Settle',
                          onPressed: isLoading ? null : _settleAlert),
                      const Spacer(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        color: AppPallete.darkGreen,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      children: [
        Text(
          '$title  ',
          style: const TextStyle(fontSize: 16, color: AppPallete.darkGreen),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: AppPallete.darkGreen),
        ),
      ],
    );
  }

  Future<void> _settleAlert() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Settle'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppPallete.brightRed),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleSettle();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.darkGreen),
              child: Text(
                'Confirm',
                style: TextStyle(color: AppPallete.backgroundColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSettle() async {
    try {
      setState(() {
        isLoading = true;
      });
      await empRemoteDatasource.settleEmployee(widget.employee.id);
      final updatedEmployee = widget.employee.copyWith(
        credit: 0,
        lastPaid: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        updatedAt: DateTime.now(),
      );
      context
          .read<EmpBloc>()
          .add(UpdateEmpEvent(updatedEmployee: updatedEmployee));
      showSnackbar(context, 'Employee has been successfully settled.', false);
    } catch (e) {
      showSnackbar(context, 'Failed to settle employee: ${e.toString()}', true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAlert(String employeeId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppPallete.brightRed),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteEmployee(employeeId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.darkGreen),
              child: Text(
                'Confirm',
                style: TextStyle(color: AppPallete.backgroundColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEmployee(String employeeId) async {
    try {
      setState(() {
        isLoading = true;
      });
      await empRemoteDatasource.deleteEmployee(widget.employee.id);
      showSnackbar(context, 'Employee has been successfully deleted.', false);
    } on Exception catch (e) {
      showSnackbar(context, 'Failed to delete employee: ${e.toString()}', true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addCreditNote(BuildContext context) {
    TextEditingController creditController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppPallete.backgroundColor,
          title: const Text(
            'Add Credit Note',
            style: TextStyle(color: AppPallete.darkGreen),
          ),
          content: InputField(
            hintText: "Enter Amount",
            controller: creditController,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.currency_rupee),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppPallete.brightRed),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final creditAmount = int.tryParse(creditController.text);
                if (creditAmount == null) {
                  showSnackbar(context, "Enter a valid credit amount", true);
                  return;
                }
                final updatedEmployee = widget.employee.copyWith(
                  credit: widget.employee.credit + creditAmount,
                );
                context
                    .read<EmpBloc>()
                    .add(UpdateEmpEvent(updatedEmployee: updatedEmployee));
                Navigator.pop(context);
                showSnackbar(context, "Credit note added successfully", false);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.darkGreen),
              child: Text(
                'Add',
                style: TextStyle(color: AppPallete.backgroundColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

Padding accountRow(String title, String value, Color valueColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppPallete.darkGreen,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.currency_rupee,
          color: valueColor,
          size: 16,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

int adjustedSalary(double salary, int totalPresents) {
  const int daysInMonth = 30;
  return ((salary * totalPresents) / daysInMonth).round();
}
