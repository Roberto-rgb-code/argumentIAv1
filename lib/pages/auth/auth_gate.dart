import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  final Widget shell;
  const AuthGate({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authState,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == null) {
          return const LoginPage();
        }
        return shell;
      },
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slide(begin: const Offset(0, .03));
  }
}
