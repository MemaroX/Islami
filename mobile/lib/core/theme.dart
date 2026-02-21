import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamiTheme {
  static const Color primaryColor = Color(0xFF004D40); // Deep Islamic Green
  static const Color accentColor = Color(0xFFFFD700); // Matte Gold
  static const Color backgroundColor = Color(0xFFF5F5F5); // Pearl White
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 16,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        showUnselectedLabels: true,
      ),
    );
  }
}
