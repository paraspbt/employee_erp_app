import 'package:emperp_app/core/GlobalBloc/global_bloc.dart';
import 'package:emperp_app/core/widgets/app_button.dart';
import 'package:emperp_app/core/widgets/input_field.dart';
import 'package:emperp_app/core/widgets/my_app_bar.dart';
import 'package:emperp_app/core/utils/show_snackbar.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/pages/emp_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEmployeePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddEmployeePage());
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployeePage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final salaryController = TextEditingController();
  final joiningDateController = TextEditingController();
  final formatter = DateFormat('dd-MM-yyyy');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    salaryController.dispose();
    joiningDateController.dispose();
    super.dispose();
  }

  void _selectJoiningDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final formattedDate = formatter.format(selectedDate);
      joiningDateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: BlocConsumer<EmpBloc, EmpState>(
        listener: (context, state) {
          if (state is EmpFailure) {
            showSnackbar(context, state.message, true);
          } else if (state is EmpSuccess) {
            Navigator.pushAndRemoveUntil(
                context, EmpListPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      InputField(
                        hintText: 'Name*',
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person),
                        isRequired: true,
                      ),
                      // TODO phone number should be 10 digits
                      const SizedBox(height: 16),
                      InputField(
                        hintText: 'Phone Number*',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone),
                        isRequired: true,
                      ),
                      //TODO salary should be numeric only
                      const SizedBox(height: 16),
                      InputField(
                        hintText: 'Salary*',
                        controller: salaryController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.currency_rupee),
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _selectJoiningDate,
                        child: AbsorbPointer(
                          child: InputField(
                            hintText: 'Joining From',
                            controller: joiningDateController,
                            prefixIcon: const Icon(Icons.date_range),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        hintText: 'Address',
                        controller: addressController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      const SizedBox(height: 48),
                      AppButton(
                        buttonText: "Save",
                        onPressed: () {
                          try {
                            if (formKey.currentState!.validate()) {
                              String joinedAt =
                                  joiningDateController.text.trim();
                              if (joinedAt.isEmpty) {
                                final now = DateTime.now();
                                joinedAt = formatter.format(now);
                              }
                              context.read<EmpBloc>().add(CreateEmpEvent(
                                  profileId: (context.read<GlobalBloc>().state
                                          as AppInState)
                                      .userModel
                                      .id,
                                  name: nameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  salary: double.parse(
                                      salaryController.text.trim()),
                                  joinedAt: joinedAt,
                                  address: addressController.text.trim()));
                            }
                          } on Exception catch (e) {
                            showSnackbar(context, e.toString(), true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (state is EmpLoading)
                const SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
