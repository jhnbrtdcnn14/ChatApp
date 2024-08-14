import 'package:chat_app/components/buttons.dart';
import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/loading.dart';
import 'package:chat_app/components/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../components/snackbar.dart';
import '../services/auth/auth_service.dart';
import '../components/inputfield.dart';
import 'homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // personal info
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _middlename = TextEditingController();
  final _number = TextEditingController();
  // account
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  void register(BuildContext context) async {
    final authService = AuthService();

    if (_number.text.length < 11) {
      showRedSnackBar(context, "Phone number should be 11 digits", 5);
      return;
    }
    if (_firstname.text.isEmpty ||
        _lastname.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _confirm.text.isEmpty) {
      // Show error message or handle empty fields
      showRedSnackBar(context, "Please fill in all required fields.", 5);
      return;
    }

    if (_password.text != _confirm.text) {
      showRedSnackBar(
          context, "Password do not match", 3); // Corrected function call
      return;
    } else {
      isLoading.value = true;
      try {
        const Loading();
        await authService.signUpWithEmailPassword(_email.text, _password.text,
            _firstname.text, _middlename.text, _lastname.text, _number.text);

        isLoading.value = false;

        // ignore: use_build_context_synchronously
        {
          showSuccessSnackBar(context, "Account Created Successfully");
        }
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } catch (e) {
        isLoading.value = false;
        String errorMessage = "Registration failed."; // Default error message
        if (e is FirebaseAuthException) {
          // Handle FirebaseAuthException
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage =
                  "This email address is already in use. Please use a different email.";
              break;
            // Add more cases for different error codes if needed
            default:
              errorMessage = "Registration failed: ${e.message}";
              break;
          }
        } else {
          // Handle other types of exceptions
          errorMessage = "Unexpected error occurred: $e";
        }
        // Show error message
        showRedSnackBar(context, errorMessage, 5);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.darkgrey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 15, 20),
          child: Center(
            // PERSONAL INFORMATION
            child: Column(children: [
              const AppText(
                  isBold: true,
                  text: "PERSONAL INFORMATION",
                  size: 20,
                  color: AppColors.blue),
              const Gap(20),

              // INPUT FIELDS
              CustomTextField(
                controller: _firstname,
                hintText: 'First name',
                isAlphabetic: true,
              ),
              const Gap(20),
              CustomTextField(
                controller: _middlename,
                hintText: 'Middle name',
                isAlphabetic: true,
              ),
              const Gap(20),
              CustomTextField(
                controller: _lastname,
                hintText: 'Last name',
                isAlphabetic: true,
              ),
              const Gap(20),
              CustomTextField(
                controller: _number,
                hintText: 'Contact number',
                isNumeric: true,
              ),
              const Gap(50),

              const AppText(
                  isBold: true,
                  text: "ACCOUNT CREDENTIALS",
                  size: 20,
                  color: AppColors.blue),
              const Gap(20),

              // INPUT FIELDS
              CustomTextField(
                controller: _email,
                hintText: 'Email',
              ),
              const Gap(20),
              CustomTextField(
                controller: _password,
                hintText: 'Password',
              ),
              const Gap(20),
              CustomTextField(
                controller: _confirm,
                hintText: 'Confirm Password',
              ),
              const Gap(40),
              ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, value, child) {
                    return value
                        ? const Loading()
                        : AppButtons(
                            onPressed: () {
                              register(context);
                            },
                            textcolor: AppColors.white,
                            color: AppColors.blue,
                            text: "Sign up");
                  }),
              const Gap(20),

              // LOGIN HERE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppText(
                      text: "Already have an account?",
                      size: 15,
                      color: AppColors.lightgrey),
                  const Gap(10),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const AppText(
                          text: "Login here",
                          size: 15,
                          isBold: true,
                          color: AppColors.lightgrey)),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
