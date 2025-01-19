import 'package:emperp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:emperp_app/features/auth/presentation/usecases/user_signup.dart';
import 'package:emperp_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  final supabase =
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  getIt.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  getIt.registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(getIt<SupabaseClient>()));

  getIt.registerFactory<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()));

  getIt.registerFactory(() => UserSignup(getIt<AuthRepositoryImpl>()));

  getIt.registerLazySingleton(() => AuthBloc(userSignup: getIt<UserSignup>()));
}
