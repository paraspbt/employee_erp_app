import 'package:emperp_app/core/theme/theme.dart';
import 'package:emperp_app/features/auth/presentation/bloc/auth_bloc.dart';
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
        create: (_) => getIt<AuthBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee-ERP',
      theme: AppTheme.appTheme,
      home: const LoginPage(),
    );
  }
}
