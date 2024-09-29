import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFFFFFFFF);

  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _errorColor = Color(0xFFCF6679);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: _surfaceColor,
      background: _backgroundColor,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundColor,
    appBarTheme: AppBarTheme(
      color: _surfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    iconTheme: IconThemeData(color: primaryColor),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: primaryColor, fontSize: 96, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: primaryColor, fontSize: 60, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: primaryColor, fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(color: primaryColor, fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(color: primaryColor.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(color: primaryColor.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w400),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: accentColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: accentColor,
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: primaryColor,
      surface: Color(0xFF121212),
      background: Color(0xFF121212),
      error: _errorColor,
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      color: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: accentColor),
      titleTextStyle: TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    iconTheme: IconThemeData(color: accentColor),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: accentColor, fontSize: 96, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: accentColor, fontSize: 60, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: accentColor, fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(color: accentColor, fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(color: accentColor, fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(color: accentColor.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(color: accentColor.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w400),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accentColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: primaryColor,
    ),
  );
}