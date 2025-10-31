import 'package:chess_game/core/constants/colors.dart';
import 'package:flutter/material.dart';

class Themes {
  final ThemeData lightMode = ThemeData(
    fontFamily: "Rubik",
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCard,
    colorScheme: const ColorScheme.light(
      primary: accentAmber,
      secondary: secondaryCyan,
      surface: lightCard,
      tertiary: darkBackground,
      error: errorRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  final ThemeData darkMode = ThemeData(
    fontFamily: "Rubik",
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCard,
    colorScheme: const ColorScheme.dark(
      primary: accentAmber,
      secondary: secondaryCyan,
      surface: darkBackground,
      tertiary: lightBackground,
      error: errorRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCard,
      foregroundColor: white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryCyan,
        foregroundColor: darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
