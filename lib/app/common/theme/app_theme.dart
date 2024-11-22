import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: false,
        colorScheme: colorScheme,
        elevatedButtonTheme: elevatedButtonTheme,
      );

  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
        ),
      );

  static final colorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xFF17192D),
    primary: Color(0xFF17192D),
    secondary: Color(0XFF2188FF),
    tertiary: Color(0xFF52C41A),
    error: Color(0xFFED3833),
    scrim: Color(0xFF17192D),
    outline: Color(0xFFEAEFF3),
    outlineVariant: Color(0xFF77818C),
  );
}
