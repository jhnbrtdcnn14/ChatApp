import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final int? newMessagesCount;

  UserTile({
    required this.text,
    required this.onTap,
    required this.newMessagesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: AppText(text: text, size: 20, color: AppColors.darkgrey),
            trailing: newMessagesCount != null && newMessagesCount! > 0
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.green,
                  )
                : null,
            onTap: onTap,
          ),
        ),
        Gap(20)
      ],
    );
  }
}
