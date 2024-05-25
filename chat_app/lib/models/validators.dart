import 'package:flutter/material.dart';

import '../components/snackbar.dart';

void InputFieldsValidator(
    BuildContext context,
    String firstname,
    String lastname,
    String email,
    String password,
    String confirm,
    String number) {
  if (firstname.isEmpty ||
      lastname.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confirm.isEmpty) {
    showRedSnackBar(context, "Please fill in all required fields.", 5);
    return;
  }

  if (number.length < 11) {
    showRedSnackBar(context, "Phone number should be 11 digits", 5);
  }

  if (password != confirm) {
    showRedSnackBar(context, "Password do not match", 3);
    return;
  }
}
