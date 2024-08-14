import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:flutter/services.dart'; // Import this package

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefix;
  final Color cursorColor;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool isNumeric; // Add this parameter
  final bool isAlphabetic; // Parameter for alphabetic input

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefix,
    this.cursorColor = Colors.grey,
    this.onChanged,
    this.focusNode,
    this.isNumeric = false, // Initialize it
    this.isAlphabetic = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      cursorColor: cursorColor,
      style: TextStyle(color: AppColors.darkgrey), // Set text color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.lightgrey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.lightgrey), // Set border color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.lightgrey), // Set border color
        ),
        prefix: prefix,
      ),
      onChanged: onChanged,
      obscureText: hintText == 'Password' || hintText == 'Confirm Password'
          ? true
          : false,
      keyboardType: isNumeric
          ? TextInputType.number
          : TextInputType.text, // Usei number keyboard if sNumeric is true
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.digitsOnly]
          : isAlphabetic
              ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))]
              : [], // Apply letter filter if isAlphabetic is true
    );
  }
}
