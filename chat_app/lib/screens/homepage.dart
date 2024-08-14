import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/text.dart';
import 'package:chat_app/screens/Account_info.dart';
import 'package:chat_app/screens/mychats.dart';
import 'package:chat_app/screens/users.dart';
import 'package:flutter/material.dart';

import '../components/bottomSheetContent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offwhite,

      // APPBAR
      appBar: AppBar(
        title: const AppText(
            text: "E-Connect",
            isBold: true,
            size: 20,
            color: AppColors.darkgrey),
        backgroundColor: AppColors.white,
        leading: IconButton(
          color: AppColors.blue,
          icon: const Icon(Icons.send),
          onPressed: () {},
          iconSize: 40,
        ),
        actions: [
          IconButton(
            color: AppColors.lightgrey,
            icon: const Icon(Icons.person_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AccountInfo()));
            },
          ),
          IconButton(
            color: AppColors.lightgrey,
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),

      // BODY
      body: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, child) {
          return value == 0 ? Users() : Mychat();
        },
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, child) => BottomNavigationBar(
          currentIndex: value,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chats"),
          ],
          onTap: (index) {
            selectedIndex.value = index;
          },
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 200,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return const BottomSheetContent();
      },
    );
  }
}
