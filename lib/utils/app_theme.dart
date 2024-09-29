import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF0000); // Nothing Red
  static const Color accentColor = Color(0xFFFFFFFF); // White

  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _errorColor = Color(0xFFCF6679);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: _surfaceColor,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundColor,
    appBarTheme: const AppBarTheme(
      color: _surfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    iconTheme: const IconThemeData(color: primaryColor),
    textTheme: TextTheme(
      displayLarge: const TextStyle(color: primaryColor, fontSize: 96, fontWeight: FontWeight.w300),
      displayMedium: const TextStyle(color: primaryColor, fontSize: 60, fontWeight: FontWeight.w300),
      displaySmall: const TextStyle(color: primaryColor, fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: const TextStyle(color: primaryColor, fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall: const TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: const TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: const TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: const TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(color: primaryColor.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(color: primaryColor.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w400),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: accentColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: accentColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: primaryColor,
      surface: Color(0xFF121212),
      error: _errorColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: accentColor),
      titleTextStyle: TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    iconTheme: const IconThemeData(color: accentColor),
    textTheme: TextTheme(
      displayLarge: const TextStyle(color: accentColor, fontSize: 96, fontWeight: FontWeight.w300),
      displayMedium: const TextStyle(color: accentColor, fontSize: 60, fontWeight: FontWeight.w300),
      displaySmall: const TextStyle(color: accentColor, fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: const TextStyle(color: accentColor, fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall: const TextStyle(color: accentColor, fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: const TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: const TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: const TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: const TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: const TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: const TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(color: accentColor.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(color: accentColor.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w400),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accentColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: primaryColor,
    ),
  );
}