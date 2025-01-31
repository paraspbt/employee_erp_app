import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/core/utils/show_snackbar.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/pages/account_page.dart';
import 'package:emperp_app/features/erp/presentation/pages/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpListPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EmpListPage());
  const EmpListPage({super.key});

  @override
  State<EmpListPage> createState() => _EmpListPageState();
}

class _EmpListPageState extends State<EmpListPage> {
  @override
  void initState() {
    super.initState();
  }

  //TODO add pull to refresh
  //TODO add no emplyee message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EmpBloc, EmpState>(
        listener: (context, state) {
          if (state is EmpFailure) {
            showSnackbar(context, state.message, true);
          }
        },
        builder: (context, state) {
          //TODO loading indicador is not alligned
          if (state is EmpLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is EmpSuccess) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Text('Employees',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.darkGreen,
                          )),
                      Spacer(),
                      Text('Credit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.darkGreen,
                          )),
                    ],
                  ),
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
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  AccountPage.route(employee: employee));
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              padding: const EdgeInsets.fromLTRB(4, 16, 4, 28),
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
                                  const Icon(
                                    Icons.currency_rupee,
                                    color: AppPallete.brightRed,
                                    size: 16,
                                  ),
                                  Text(
                                    employee.credit.toInt().toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: AppPallete.brightRed,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AddEmployeePage.route());
        },
        backgroundColor: AppPallete.backgroundColor,
        foregroundColor: AppPallete.darkGreen,
        shape: const CircleBorder(),
        tooltip: 'Add New Employee',
        child: const Icon(
          Icons.add,
          color: AppPallete.darkGreen,
          size: 40,
        ),
      ),
    );
  }
}
