import 'package:flutter/material.dart';

ThemeData globalTheme() {
  return ThemeData(
    // Primary colors
    primaryColor: Colors.red,
    primaryColorLight: Colors.red[300],
    primaryColorDark: Colors.red[700],

    // Accent color
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
      accentColor: Colors.white,
    ),

    // Background colors
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,

    // App bar theme
    appBarTheme: const AppBarTheme(
      color: Colors.red,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),

    // Text themes
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
      bodySmall: TextStyle(color: Colors.black54, fontSize: 14),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      border: OutlineInputBorder(),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: Colors.red,
    ),
  );
}