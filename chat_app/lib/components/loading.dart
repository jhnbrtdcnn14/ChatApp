import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'colors.dart';
import 'text.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(color: AppColors.blue),
      Gap(20),
      AppText(text: "Loading...", size: 25, color: AppColors.blue)
    ]));
  }
}
