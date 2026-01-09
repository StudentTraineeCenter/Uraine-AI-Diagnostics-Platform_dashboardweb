// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uraine_web/firebase_options.dart';
import 'package:uraine_web/auth_wrapper.dart'; // Uisti sa, že import sedí
import 'package:uraine_web/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UraineMdApp());
}

class UraineMdApp extends StatelessWidget {
  const UraineMdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URAINE MD Portál',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryBlue,
          secondary: AppColors.actionGreen,
        ),
        useMaterial3: true,
      ),
      // VRÁTIME AUTH WRAPPER - Toto zabezpečí prihlásenie a prístup k DB
      home: const AuthWrapper(), 
    );
  }
}