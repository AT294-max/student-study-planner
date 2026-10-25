import 'package:flutter/material.dart';

/// Centralized modern dark theme for the Student Study Planner.
class AppTheme {
  // Brand color palette
  static const Color background = Color(0xFF0F172A); // Deep navy (slate-900)
  static const Color cardNavy = Color(
    0xFF1E293B,
  ); // Slightly lighter navy (slate-800)
  static const Color cardNavyElevated = Color(0xFF27354A); // Surface highlight
  static const Color primaryAccent = Color(0xFF6366F1); // Indigo accent
  static const Color secondaryAccent = Color(0xFF818CF8); // Soft indigo
  static const Color purpleAccent = Color(0xFF8B5CF6); // Soft purple
  static const Color completedGreen = Color(0xFF22C55E); // Emerald green
  static const Color pendingAmber = Color(0xFFF59E0B); // Amber warning
  static const Color textPrimary = Color(0xFFF8FAFC); // Crisp white
  static const Color textMuted = Color(0xFF94A3B8); // Muted slate gray
  static const Color borderSlate = Color(0xFF334155); // Subtle border

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        onPrimary: Colors.white,
        secondary: secondaryAccent,
        onSecondary: Colors.white,
        surface: cardNavy,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardNavy,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSlate, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: primaryAccent.withAlpha(50),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: secondaryAccent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: secondaryAccent, size: 24);
          }
          return const IconThemeData(color: textMuted, size: 24);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderSlate, width: 1),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardNavyElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSlate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSlate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textMuted),
        hintStyle: const TextStyle(color: textMuted),
      ),
    );
  }
}
