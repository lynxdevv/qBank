import 'package:flutter/material.dart';

class AppColors {
  static const gradientStart = Color(0xFF1A2980);
  static const gradientEnd = Color(0xFF26D0CE);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A7D), Color(0xFF22B1CE)],
  );

  static const darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D1B3E), Color(0xFF1A2980)],
  );

  static const surface = Color(0xFF0D1B3E);
  static const surfaceLight = Color(0xFF162350);
  static const cardBg = Color(0xFF162350);
  static const accentCyan = Color(0xFF26D0CE);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0BEC5);
  static const doneGreen = Color(0xFF4CAF50);
  static const importanceGold = Color(0xFFFFD700);
  static const essayColor = Color(0xFF7C4DFF);
  static const shortColor = Color(0xFFFF6E40);
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}
