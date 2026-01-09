// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF2C3E50);
  static const Color actionGreen = Color(0xFF2ECC71);
  static const Color errorRed = Color(0xFFE74C3C);
  static const Color warningOrange = Color(0xFFF39C12);
  static const Color background = Color(0xFFF5F7FA);
  static const Color white = Colors.white;
  static const Color textGrey = Color(0xFF7F8C8D);

  // --- PRIDANÉ CHÝBAJÚCE FARBY (FIX) ---
  static const Color textDark = Color(0xFF2C3E50); // Tmavá pre texty
  static const Color secondaryGreen = Color(0xFF2ECC71); // Sekundárna zelená
  // -------------------------------------

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}