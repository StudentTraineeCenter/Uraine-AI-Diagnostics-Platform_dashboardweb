// lib/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uraine_web/screens/login_screen.dart'; // Musíš mať tento screen
import 'package:uraine_web/screens/main_shell.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Čakáme na overenie stavu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Ak je user prihlásený, pustíme ho dnu
        if (snapshot.hasData) {
          return const MainShell();
        }

        // Ak nie je, ukážeme Login
        return const LoginScreen();
      },
    );
  }
}