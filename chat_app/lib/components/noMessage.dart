import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'colors.dart';
import 'text.dart';

class noMessage extends StatelessWidget {
  const noMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.message,
          color: AppColors.blue,
          size: 100,
        ),
        Gap(20),
        AppText(text: "No messages yet", size: 20, color: AppColors.darkgrey),
      ],
    ));
  }
}
