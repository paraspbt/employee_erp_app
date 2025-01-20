import 'package:emperp_app/core/GlobalBloc/global_bloc.dart';
import 'package:emperp_app/core/theme/theme.dart';
import 'package:emperp_app/features/auth/presentation/AuthBloc/auth_bloc.dart';
import 'package:emperp_app/features/auth/presentation/pages/login_page.dart';
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
      home: BlocSelector<GlobalBloc, GlobalState, bool>(
        selector: (state) {
          if (state is AppUserLoggedIn) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state == true) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Logged In Welcome to Home page',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
