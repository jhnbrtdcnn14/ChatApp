import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../components/editableDetailsTile.dart';
import '../components/snackbar.dart';
import '../components/text.dart';
import '../services/auth/auth_service.dart';

class AccountInfo extends StatefulWidget {
  final bool isEditable;
  const AccountInfo({
    super.key,
    this.isEditable = false,
  });

  @override
  EditAccountState createState() => EditAccountState();
}

class EditAccountState extends State<AccountInfo> {
  ValueNotifier<Map<String, dynamic>>? userData;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final authService = AuthService();
    try {
      Map<String, dynamic> data = await authService.getUserData();
      userData = ValueNotifier(data);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      // Handle error
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> saveUserData() async {
    isLoading.value = true;
    final authService = AuthService();

    try {
      debugPrint("Saving user data: ${userData?.value}");
      await authService.updateUserData(userData?.value ?? {});
      isLoading.value = false;
      // Show snack bar on success
      if (mounted) {
        showSuccessSnackBar(context, "Information saved Successfully");
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error saving user data: $e");
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
          text: widget.isEditable ? "Edit Account" : "Profile Information",
          isBold: true,
          size: 25,
          color: AppColors.darkgrey,
        ),
        actions: [
          widget.isEditable
              ? IconButton(
                  icon: const Icon(Icons.save, color: AppColors.blue),
                  onPressed: saveUserData,
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return value
              ? const Center(child: Loading())
              : userData == null
                  ? const Center(child: Text("No user data found"))
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Gap(30),
                          const Row(
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
                          const Gap(30),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EditableDetailsTile(
                                    title: "First Name:",
                                    detail: "${userData?.value['firstname']}",
                                    isEditable: widget.isEditable,
                                    onSave: (value) {
                                      setState(() {
                                        userData?.value['firstname'] = value;
                                      });
                                    },
                                  ),
                                  EditableDetailsTile(
                                    title: "Middle Name:",
                                    detail: "${userData?.value['middlename']}",
                                    isEditable: widget.isEditable,
                                    onSave: (value) {
                                      setState(() {
                                        userData?.value['middlename'] = value;
                                      });
                                    },
                                  ),
                                  EditableDetailsTile(
                                    title: "Last Name:",
                                    detail: "${userData?.value['lastname']}",
                                    isEditable: widget.isEditable,
                                    onSave: (value) {
                                      setState(() {
                                        userData?.value['lastname'] = value;
                                      });
                                    },
                                  ),
                                  EditableDetailsTile(
                                    title: "Email:",
                                    detail: "${userData?.value['email']}",
                                    isEditable: widget.isEditable,
                                    onSave: (value) {
                                      setState(() {
                                        userData?.value['email'] = value;
                                      });
                                    },
                                  ),
                                  EditableDetailsTile(
                                    title: "Phone Number:",
                                    detail: "${userData?.value['phoneNumber']}",
                                    isEditable: widget.isEditable,
                                    onSave: (value) {
                                      setState(() {
                                        userData?.value['phoneNumber'] = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
