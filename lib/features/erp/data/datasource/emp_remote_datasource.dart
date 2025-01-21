import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmpRemoteDatasource {
  final SupabaseClient supabaseClient;
  EmpRemoteDatasource(this.supabaseClient);
  Future<EmployeeModel> createEmployee(EmployeeModel employeeModel) async {
    try {
      final res = await supabaseClient
          .from('employees')
          .insert(employeeModel.toMap())
          .select();
      print('tag: ${res.first}');
      return EmployeeModel.fromMap(res.first);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
