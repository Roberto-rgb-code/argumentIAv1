import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import 'login_page_simple.dart';

class AuthGate extends StatelessWidget {
  final Widget shell;
  const AuthGate({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authState,
      builder: (context, snap) {
        // Si está cargando, mostrar loading simple
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Si hay usuario autenticado, mostrar la app
        if (snap.hasData && snap.data != null) {
          return shell;
        }
        
        // Si no hay usuario, mostrar login
        return const LoginPageSimple();
      },
    );
  }
}
