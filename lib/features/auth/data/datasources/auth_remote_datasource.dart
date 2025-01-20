import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabaseClient;
  AuthRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('User is null error');
      }
      final juser = response.user!.toJson();
      final userModel = UserModel.fromJson(juser);
      return userModel;
    } on Exception catch (e) {
      if (e.toString().contains('Invalid login credentials')) {
        throw Exception('Invalid Login Credentials');
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      if (response.user == null) {
        throw Exception('User is null error');
      }
      final juser = response.user!.toJson();
      final userModel = UserModel.fromJson(juser);
      return userModel;
    } on Exception catch (e) {
      if (e.toString().contains('already registered')) {
        throw Exception('Already Registered');
      }
      throw Exception(e.toString());
    }
  }
}
