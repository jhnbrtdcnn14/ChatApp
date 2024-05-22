import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'colors.dart';
import 'text.dart';

// ignore: must_be_immutable
class DetailsTile extends StatelessWidget {
  String title;
  String detail;
  DetailsTile({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              AppText(
                text: title,
                size: 18,
                color: AppColors.blue,
                isBold: true,
              ),
              Gap(20),
              AppText(text: detail, size: 20, color: AppColors.darkgrey)
            ],
          ),
        ),
        Gap(20)
      ],
    );
  }
}
