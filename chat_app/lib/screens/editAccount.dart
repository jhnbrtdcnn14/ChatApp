import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../components/editableDetailsTile.dart';
import '../components/snackbar.dart';
import '../components/text.dart';
import '../services/auth/auth_service.dart';

class editAccount extends StatefulWidget {
  @override
  _editAccountState createState() => _editAccountState();
}

class _editAccountState extends State<editAccount> {
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

  Future<void> saveUserData() async {
    setState(() {
      isLoading = true;
    });
    final authService = AuthService();
    try {
      print("Saving user data: $userData");
      await authService.updateUserData(
          userData!); // Ensure this method exists in AuthService
      setState(() {
        isLoading = false;
      });

      // Show snack bar on success
      showSuccessSnackBar(context, "Information saved Successfully");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error saving user data: $e");
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
          text: "Edit Account",
          isBold: true,
          size: 25,
          color: AppColors.darkgrey,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: AppColors.blue),
            onPressed: saveUserData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: Loading())
          : userData == null
              ? Center(child: Text("No user data found"))
              : SingleChildScrollView(
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
                              EditableDetailsTile(
                                  title: "First Name:",
                                  detail: "${userData!['firstname']}",
                                  onSave: (value) {
                                    setState(() {
                                      userData!['firstname'] = value;
                                    });
                                  }),
                              EditableDetailsTile(
                                  title: "Middle Name:",
                                  detail: "${userData!['middlename']}",
                                  onSave: (value) {
                                    setState(() {
                                      userData!['middlename'] = value;
                                    });
                                  }),
                              EditableDetailsTile(
                                  title: "Last Name:",
                                  detail: "${userData!['lastname']}",
                                  onSave: (value) {
                                    setState(() {
                                      userData!['lastname'] = value;
                                    });
                                  }),
                              EditableDetailsTile(
                                  title: "Email:",
                                  detail: "${userData!['email']}",
                                  onSave: (value) {
                                    setState(() {
                                      userData!['email'] = value;
                                    });
                                  }),
                              EditableDetailsTile(
                                  title: "Phone Number:",
                                  detail: "${userData!['phoneNumber']}",
                                  onSave: (value) {
                                    setState(() {
                                      userData!['phoneNumber'] = value;
                                    });
                                  }),
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
