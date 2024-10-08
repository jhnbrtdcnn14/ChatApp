import 'package:chat_app/components/buttons.dart';
import 'package:chat_app/components/colors.dart';
import 'package:chat_app/screens/Account_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../services/auth/auth_service.dart';
import 'text.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, size: 80, color: AppColors.blue),
              Gap(10),
              AppText(
                  text: "E-Connect",
                  isBold: true,
                  size: 30,
                  color: AppColors.darkgrey),
            ],
          ),
          const Gap(50),

          //list tile home
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              leading: const Icon(
                Icons.home,
                color: AppColors.darkgrey,
              ),
              title: const AppText(
                text: "Home",
                isBold: true,
                size: 20,
                color: AppColors.darkgrey,
              ),
            ),
          ),

          // list tile edit account

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: ListTile(
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountInfo(
                              isEditable: true,
                            )));
              },
              leading: const Icon(
                Icons.edit,
                color: AppColors.darkgrey,
              ),
              title: const AppText(
                text: "Edit Personal Info",
                isBold: true,
                size: 20,
                color: AppColors.darkgrey,
              ),
            ),
          ),
          const Gap(50),

          // List Tile logout
          AppButtons(
            onPressed: () {
              // Call the logout function
              logout();
              // Close the bottom sheet
              Navigator.of(context).pop();
            },
            textcolor: AppColors.blue,
            color: AppColors.white,
            text: "Logout",
          ),
        ],
      ),
    );
  }
}

logout() {
  final authService = AuthService();
  authService.signOut();
}
