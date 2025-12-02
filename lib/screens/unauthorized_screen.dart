// lib/screens/unauthorized_screen.dart

import 'package:flutter/material.dart';
import 'package:uraine_web/services/auth_service.dart'; // Importujeme service

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Rovnaké pozadie ako login
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikonka chyby
              const Icon(
                Icons.gpp_bad_outlined, // Ikona "zlého" zabezpečenia
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 24),
              const Text(
                "Prístup Zamietnutý",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Nemáte oprávnenie na prístup k portálu URAINE MD. Tento portál je určený iba pre lekársky personál.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Použijeme service na odhlásenie
                    authService.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Modré tlačidlo
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Späť na Prihlásenie"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}