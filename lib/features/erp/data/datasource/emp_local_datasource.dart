import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:hive/hive.dart';

class EmpLocalDatasource {
  final Box box;
  EmpLocalDatasource(this.box);

  void uploadEmployees(List<EmployeeModel> employees) {
    box.clear();
    for (int i = 0; i < employees.length; i++) {
      box.put(i.toString(), employees[i].toMap());
    }
  }

  List<EmployeeModel> loadEmployees() {
  List<EmployeeModel> employees = [];
  for (int i = 0; i < box.length; i++) {
    final employeeMap = box.get(i.toString());
    if (employeeMap != null) {
      final employeeData = Map<String, dynamic>.from(employeeMap);
      employees.add(EmployeeModel.fromMap(employeeData));
    }
  }
  return employees;
}
}
