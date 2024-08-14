import 'package:chat_app/components/loading.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/homepage.dart';
import '../../screens/login_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authstate = ref.watch(authStateProvider);

    return Scaffold(
        body: authstate.when(
      data: (user) {
        if (user == null) {
          return const LoginPage();
        } else {
          return const HomePage();
        }
      },
      loading: () => const Center(child: Loading()),
      error: (error, stackTrace) {
        return const Center(child: Text('An error occurred'));
      },
    ));
  }
}
