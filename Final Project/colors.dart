import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E3A8A); // Deep blue
  static const Color secondary = Color(0xFF3B82F6); // Light blue
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color background = Color(0xFFF8FAFC); // Light gray
  static const Color textPrimary = Color(0xFF1F2937); // Dark gray
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color error = Color(0xFFEF4444); // Red
  static const Color success = Color(0xFF10B981); // Green

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}