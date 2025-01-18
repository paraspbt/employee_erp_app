import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/features/auth/presentation/pages/signup_page.dart';
import 'package:emperp_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:emperp_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 144,),
                const Text(
                  "Log In.",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.darkGreen),
                ),
                const SizedBox(height: 32),
                AuthField(
                  hintText: "Email",
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                AuthField(
                  hintText: "Password",
                  controller: passwordController,
                  isObscureText: true,
                ),
                const SizedBox(height: 32),
                AuthButton(buttonText: "Log In", onPressed: () {}),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SignupPage.route());
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(fontSize: 20, color: AppPallete.dullGreen),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                              fontSize: 20,
                              color: AppPallete.brightGreen,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
