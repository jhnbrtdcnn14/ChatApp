import 'package:flutter/material.dart';

import 'colors.dart';

class AppButtons extends StatelessWidget {
  final String text;
  final Color textcolor;
  final Function onPressed;
  final Color color;

  const AppButtons({
    super.key,
    required this.onPressed,
    required this.textcolor,
    required this.color,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onPressed();
              }, // Placeholder: add your onPressed action
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius here
                ),
                backgroundColor: color, // Button background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                elevation: 5.0, // Optional: Add a slight elevation
              ),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textcolor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppButtonsFlat extends StatelessWidget {
  final String text;
  final Color textcolor;
  final Function onPressed;
  final Color color;

  const AppButtonsFlat({
    super.key,
    required this.onPressed,
    required this.textcolor,
    required this.color,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onPressed();
              }, // Placeholder: add your onPressed action
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppColors.blue, width: 1),
                  // Set the border radius here
                ),
                backgroundColor: color,
                // Button background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                elevation: 0.0, // Optional: Add a slight elevation
              ),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textcolor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
