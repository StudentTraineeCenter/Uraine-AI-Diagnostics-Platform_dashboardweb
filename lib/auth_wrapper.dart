// lib/auth_wrapper.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Naše tri obrazovky, medzi ktorými prepíname
import 'package:uraine_web/screens/login_screen.dart';
import 'package:uraine_web/screens/main_shell.dart';
import 'package:uraine_web/screens/unauthorized_screen.dart'; // <-- Import novej obrazovky

import 'package:uraine_web/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        
        // Kým čakáme na odpoveď z Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // KROK 1: Je niekto prihlásený?
        if (snapshot.hasData) {
          // Áno, niekto je prihlásený. Získame jeho údaje.
          final user = snapshot.data!;

          // KROK 2: Je to lekár? (Naša dočasná kontrola)
          
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // !!! TU VLOŽ EMAIL LEKÁRA, KTORÉHO SI VYTVORIL V KROKU 1 !!!
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          const String administratorskyEmail = "lekar.test@uraine.sk";

          if (user.email == administratorskyEmail) {
            // ÁNO, je to lekár. Pustíme ho do aplikácie.
            return const MainShell();
          } else {
            // ÁNO, je prihlásený, ALE NIE JE lekár (je to pacient).
            // Ukážeme mu obrazovku "Prístup Zamietnutý".
            return const UnauthorizedScreen();
          }
        }

        // KROK 3: Nikto nie je prihlásený.
        // Ukážeme prihlasovaciu obrazovku.
        return LoginScreen();
      },
    );
  }
}