import 'package:emperp_app/features/erp/data/models/employee_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmpRemoteDatasource {
  final SupabaseClient supabaseClient;
  EmpRemoteDatasource(this.supabaseClient);

  Future<List<EmployeeModel>> getEmployees(String profileId) async {
    try {
      final res = await supabaseClient
          .from('employees')
          .select()
          .eq('profile_id', profileId);
      return (res as List)
          .map((employee) => EmployeeModel.fromMap(employee))
          .toList();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<EmployeeModel> createEmployee(EmployeeModel employeeModel) async {
    try {
      final res = await supabaseClient
          .from('employees')
          .insert(employeeModel.toMap())
          .select();
      return EmployeeModel.fromMap(res.first);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateEmployee(EmployeeModel updatedEmployee) async {
    try {
      
      await supabaseClient
          .from('employees')
          .update(updatedEmployee.toMap())
          .eq('id', updatedEmployee.id);
    } on Exception catch (e) {
      throw Exception('Failed to update employee: ${e.toString()}');
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      
      await supabaseClient
          .from('employees')
          .delete()
          .eq('id', employeeId);
    } on Exception catch (e) {
      throw Exception('Failed to delete employee: ${e.toString()}');
    }
  }



  Future<void> updateAttendance(
      List<MapEntry<String, String?>> validEntries) async {
    try {
      if (validEntries.isEmpty) return;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      for (var entry in validEntries) {
        final employeeId = entry.key;
        final isPresent = (entry.value == 'P');
        final update = {
          'employee_id': employeeId,
          'is_present': isPresent,
          'date': date,
        };
        await supabaseClient
            .from('attendance')
            .upsert(update, onConflict: 'employee_id,date');
      }
    } on Exception catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<MapEntry<String, bool>>> fetchAttendance(
      String employeeId) async {
    try {
      final res = await supabaseClient
          .from('attendance')
          .select('date, is_present')
          .eq('employee_id', employeeId);
      final fetchedAttendance = (res as List)
          .map((record) => MapEntry(
                record['date'] as String,
                record['is_present'] as bool,
              ))
          .toList();
      fetchedAttendance.sort((a, b) => b.key.compareTo(a.key));
      return fetchedAttendance;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> settleEmployee(String employeeId) async {
    try {
      await supabaseClient
          .from('attendance')
          .delete()
          .eq('employee_id', employeeId);
    } on Exception catch (e) {
      throw Exception('Failed to settle employee: ${e.toString()}');
    }
  }
}
