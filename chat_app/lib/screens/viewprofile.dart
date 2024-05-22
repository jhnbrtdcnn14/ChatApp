import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/detailTile.dart';
import 'package:chat_app/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../components/text.dart';
import '../services/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final authService = AuthService();
    try {
      Map<String, dynamic> data = await authService.getUserData();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        title: AppText(
          text: "Profile Information",
          isBold: true,
          size: 25,
          color: AppColors.darkgrey,
        ),
      ),
      body: isLoading
          ? Center(child: Loading())
          : userData == null
              ? Center(child: Text("No user data found"))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded,
                              size: 80, color: AppColors.blue),
                          Gap(20),
                          AppText(
                              text: "E-Connect",
                              isBold: true,
                              size: 30,
                              color: AppColors.darkgrey),
                        ],
                      ),
                      Gap(30),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailsTile(
                                  title: "First Name:",
                                  detail: "${userData!['firstname']}"),
                              DetailsTile(
                                  title: "Middle Name:",
                                  detail: "${userData!['middlename']}"),
                              DetailsTile(
                                  title: "Last Name:",
                                  detail: "${userData!['lastname']}"),
                              DetailsTile(
                                  title: "Email:",
                                  detail: " ${userData!['email']}"),
                              DetailsTile(
                                  title: "Phone Number:",
                                  detail: " ${userData!['phoneNumber']}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
