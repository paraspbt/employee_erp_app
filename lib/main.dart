import 'package:emperp_app/core/GlobalBloc/global_bloc.dart';
import 'package:emperp_app/core/NavBloc/navigation_bloc.dart';
import 'package:emperp_app/core/theme/theme.dart';
import 'package:emperp_app/features/auth/presentation/AuthBloc/auth_bloc.dart';
import 'package:emperp_app/features/auth/presentation/pages/login_page.dart';
import 'package:emperp_app/features/erp/Attbloc/attendance_bloc.dart';
import 'package:emperp_app/features/erp/presentation/EmpBloc/emp_bloc.dart';
import 'package:emperp_app/features/erp/presentation/pages/main_screen.dart';
import 'package:emperp_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => getIt<GlobalBloc>(),
      ),
      BlocProvider(
        create: (_) => getIt<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => getIt<EmpBloc>(),
      ),
      BlocProvider(
        create: (_) => getIt<NavigationBloc>(),
      ),
      BlocProvider(
        create: (_) => getIt<AttendanceBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserLoggedInCheck());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee-ERP',
      theme: AppTheme.appTheme,
      home: BlocConsumer<GlobalBloc, GlobalState>(
        listener: (context, state) {
          if (state is AppInState) {
            context
                .read<EmpBloc>()
                .add(GetEmployeesEvent(profileId: state.userModel.id));
          }
        },
        builder: (context, state) {
          if (state is AppInState) {
            return const MainScreen();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
