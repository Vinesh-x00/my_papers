import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        primary: Colors.grey.shade800,
        secondary: Colors.grey.shade700,
        inversePrimary: Colors.grey.shade300),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.green, // Change cursor color here
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color // Button color
        side: BorderSide(color: Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Button text color
      ),
    ));
