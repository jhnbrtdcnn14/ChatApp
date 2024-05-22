import 'package:chat_app/components/snackbar.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/buttons.dart';
import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../components/inputfield.dart';
import '../components/loading.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      setState(() {
        isLoading = true;
      });
      Loading();
      await authService.signInWithEmailPassword(
          _usernameController.text, _passwordController.text);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showRedSnackBar(
          context,
          e.toString(),
          // "Authentication FAILED. The account credentials may be incorrect. Please try again.",
          3);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            // LOGO
            child: Column(children: [
              const Gap(40),
              const Icon(Icons.send_rounded, size: 120, color: AppColors.blue),
              const Gap(10),
              const AppText(
                  text: "E-Connect",
                  isBold: true,
                  size: 50,
                  color: AppColors.darkgrey),

              const Gap(10),
              const AppText(
                  text: "Connect to anyone, anytime, anywhere.",
                  size: 18,
                  color: AppColors.lightgrey),
              const Gap(50),

              // INPUT FIELDS
              CustomTextField(
                controller: _usernameController,
                hintText: 'Email',
              ),
              Gap(20),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
              ),
              Gap(20),

              // FORGOT PASSWORD
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Aligning to the right side
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const AppText(
                          text: "Forgot Password?",
                          size: 15,
                          color: AppColors.lightgrey)),
                ],
              ),
              Gap(30),

              isLoading
                  ? const Loading()
                  : // BUTTONS
                  AppButtons(
                      onPressed: () {
                        login(context);
                      },
                      textcolor: AppColors.white,
                      color: AppColors.blue,
                      text: "Login"),

              Gap(20),
              Stack(
                children: [
                  const Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: AppColors.offwhite,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        color: AppColors.white,
                        alignment: Alignment.center,
                        child: const Text(
                          "or",
                          style: TextStyle(
                            color: AppColors.lightgrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20),

              AppButtonsFlat(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                    print("Sign Up");
                  },
                  textcolor: AppColors.blue,
                  color: AppColors.white,
                  text: "Sign Up"),
              Gap(50),
            ]),
          ),
        ),
      ),
    );
  }
}
