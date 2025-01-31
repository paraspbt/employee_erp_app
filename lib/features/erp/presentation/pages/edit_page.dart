import 'package:emperp_app/core/widgets/app_button.dart';
import 'package:emperp_app/core/widgets/my_app_bar.dart';
import 'package:emperp_app/core/utils/show_snackbar.dart';
import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/pages/main_screen.dart';
import 'package:emperp_app/features/erp/presentation/widgets/edit_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final EmployeeModel employee;
  static route({required EmployeeModel employee}) => MaterialPageRoute(
      builder: (context) => EditPage(
            employee: employee,
          ));

  const EditPage({super.key, required this.employee});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final salaryController = TextEditingController();
  final joiningDateController = TextEditingController();
  final absentController = TextEditingController();
  final creditController = TextEditingController();
  final lastPaidController = TextEditingController();
  final noteController = TextEditingController();
  final formatter = DateFormat('dd-MM-yyyy');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    salaryController.dispose();
    joiningDateController.dispose();
    creditController.dispose();
    lastPaidController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<EmpBloc>().state;

    if (state is EmpSuccess) {
      nameController.text = widget.employee.name;
      phoneController.text = widget.employee.phone;
      addressController.text = widget.employee.address ?? '';
      salaryController.text = widget.employee.salary.toString();
      joiningDateController.text = widget.employee.joinedAt;
      creditController.text = widget.employee.credit.toString();
      lastPaidController.text = widget.employee.lastPaid;
      noteController.text = widget.employee.note ?? '';
    }
  }

  void _selectDate(TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final formattedDate = formatter.format(selectedDate);
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<EmpBloc, EmpState>(
          listener: (context, state) {
            if (state is EmpFailure) {
              showSnackbar(context, 'Failed State', true);
            } else if (state is EmpSuccess) {
              Navigator.pushAndRemoveUntil(
                  context, MainScreen.route(), (route) => false);
            }
          },
          builder: (context, state) {
            if (state is EmpFailure) {
              return const Center(
                  child: Text('Failed to load employee details.'));
            }
            if (state is EmpLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildField(
                        label: 'Name',
                        controller: nameController,
                        isRequired: true,
                        icon: const Icon(Icons.person)),
                    _buildField(
                        label: 'Phone',
                        controller: phoneController,
                        isRequired: true,
                        icon: const Icon(Icons.phone),
                        keyboardType: TextInputType.phone),
                    _buildField(
                        label: 'Salary',
                        controller: salaryController,
                        isRequired: true,
                        icon: const Icon(Icons.currency_rupee),
                        keyboardType: TextInputType.number),
                    _buildField(
                        label: 'Credit',
                        controller: creditController,
                        isRequired: true,
                        icon: const Icon(Icons.currency_exchange),
                        keyboardType: TextInputType.number),
                    GestureDetector(
                      onTap: () => _selectDate(lastPaidController),
                      child: AbsorbPointer(
                        child: _buildField(
                            label: 'Last Paid Date',
                            controller: lastPaidController,
                            icon: const Icon(Icons.date_range)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(joiningDateController),
                      child: AbsorbPointer(
                        child: _buildField(
                            label: 'Joined On',
                            controller: joiningDateController,
                            icon: const Icon(Icons.calendar_today)),
                      ),
                    ),
                    _buildField(
                        label: 'Address',
                        controller: addressController,
                        icon: const Icon(Icons.location_on),
                        keyboardType: TextInputType.multiline),
                    _buildField(
                        label: 'Note',
                        controller: noteController,
                        icon: const Icon(Icons.note),
                        keyboardType: TextInputType.multiline),
                    const SizedBox(height: 32),
                    AppButton(
                      buttonText: 'Save',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<EmpBloc>().add(UpdateEmpEvent(
                                updatedEmployee: widget.employee.copyWith(
                                  name: nameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  salary: double.tryParse(
                                          salaryController.text.trim()) ??
                                      0.0,
                                  credit: double.tryParse(
                                          creditController.text.trim()) ??
                                      0.0,
                                  joinedAt: joiningDateController.text.trim(),
                                  lastPaid: lastPaidController.text.trim(),
                                  address: addressController.text.trim(),
                                  note: noteController.text.trim(),
                                  updatedAt: DateTime.now(),
                                ),
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    Widget? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      children: [
        EditInputField(
          label: label,
          hintText: isRequired ? '$label*' : label,
          controller: controller,
          prefixIcon: icon,
          keyboardType: keyboardType ?? TextInputType.text,
          isRequired: isRequired,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
