import 'package:emperp_app/core/GlobalBloc/global_bloc.dart';
import 'package:emperp_app/core/NavBloc/navigation_bloc.dart';
import 'package:emperp_app/core/network/connection_check.dart';
import 'package:emperp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:emperp_app/features/auth/presentation/usecases/current_user.dart';
import 'package:emperp_app/features/auth/presentation/usecases/user_login.dart';
import 'package:emperp_app/features/auth/presentation/usecases/user_signup.dart';
import 'package:emperp_app/features/auth/presentation/AuthBloc/auth_bloc.dart';
import 'package:emperp_app/features/erp/Attbloc/attendance_bloc.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_local_datasource.dart';
import 'package:emperp_app/features/erp/data/datasource/emp_remote_datasource.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/usecases/create_employee.dart';
import 'package:emperp_app/features/erp/presentation/usecases/get_employees.dart';
import 'package:emperp_app/features/erp/presentation/usecases/update_attendance.dart';
import 'package:emperp_app/features/erp/presentation/usecases/update_employee.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
 
  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  final supabase = await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  getIt.registerLazySingleton(() => supabase.client);


  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  final employeesBox = await Hive.openBox('employees');
  getIt.registerLazySingleton(() => employeesBox);

 
  getIt.registerFactory(() => InternetConnection());
  getIt.registerFactory(() => ConnectionCheck(getIt<InternetConnection>()));

  _initAuth();
  _initEmp();
  _initNav();
  _initAtt();
}

void _initAuth() {
  final String currdate = DateFormat.MMMMEEEEd().format(DateTime.now());

  getIt.registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(getIt<SupabaseClient>()));

  getIt.registerFactory<AuthRepositoryImpl>(() => AuthRepositoryImpl(
      getIt<AuthRemoteDatasource>(), getIt<ConnectionCheck>()));

  getIt.registerFactory(() => UserSignup(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => UserLogin(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => CurrentUser(getIt<AuthRepositoryImpl>()));

  getIt.registerLazySingleton(() => GlobalBloc(currdate: currdate));

  getIt.registerLazySingleton(
    () => AuthBloc(
      userSignup: getIt<UserSignup>(),
      userLogin: getIt<UserLogin>(),
      currentUser: getIt<CurrentUser>(),
      globalBloc: getIt<GlobalBloc>(),
    ),
  );
}

void _initEmp() {
  getIt.registerFactory(() => EmpRemoteDatasource(getIt<SupabaseClient>()));

  getIt.registerFactory(() => EmpLocalDatasource(getIt<Box>()));

  getIt.registerFactory(() =>
      CreateEmployee(getIt<EmpRemoteDatasource>(), getIt<ConnectionCheck>()));

  getIt.registerFactory(() => GetEmployees(getIt<EmpRemoteDatasource>(),
      getIt<EmpLocalDatasource>(), getIt<ConnectionCheck>()));

  getIt.registerFactory(() => UpdateEmployee(getIt<EmpRemoteDatasource>()));

  getIt.registerLazySingleton(() => EmpBloc(
        createEmployee: getIt<CreateEmployee>(),
        getEmployees: getIt<GetEmployees>(),
        updateEmployee: getIt<UpdateEmployee>(),
      ));
}

void _initNav() {
  getIt.registerLazySingleton(() => NavigationBloc());
}

void _initAtt() {
  getIt.registerFactory(() => UpdateAttendance(getIt<EmpRemoteDatasource>()));
  getIt.registerLazySingleton(
      () => AttendanceBloc(updateAttendance: getIt<UpdateAttendance>()));
}
