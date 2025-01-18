import 'package:emperp_app/core/theme/theme.dart';
import 'package:emperp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emperp_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:emperp_app/features/auth/domain/usecases/user_signup.dart';
import 'package:emperp_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emperp_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  // TODO : Implement error message and remove force unwarp
  final supabase = await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthBloc(
          userSignup: UserSignup(
            AuthRepositoryImpl(
              AuthRemoteDatasourceImpl(supabase.client),
            ),
          ),
        ),
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
