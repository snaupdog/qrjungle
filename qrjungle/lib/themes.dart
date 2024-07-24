import 'package:flutter/material.dart';

Color lightPrimaryColor = const Color(0xFFFFF5E1);
Color darkPrimaryColor = const Color(0xFF121212);

Color lightSecondaryColor = const Color(0xFFFF6969);
Color darkSecondaryColor = const Color(0xff1b1b1b);

Color lightTextColor = const Color(0xFF000000);
Color darkTextColor = const Color(0xFFF0F3FF);

Color lightaccentColor = const Color(0xFF6CCEFF);
Color darkaccentcolor = const Color(0xFF6CCEFF);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: lightPrimaryColor,
    secondary: darkSecondaryColor,
    onPrimary: lightaccentColor,
    tertiary: Colors.black,
    tertiaryContainer: const Color(0xffB1AFFF),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: lightPrimaryColor,
    titleTextStyle: TextStyle(
      color: lightaccentColor,
      fontFamily: 'NunitoSans',
      fontSize: 20,
    ),
  ),
  scaffoldBackgroundColor: lightPrimaryColor,
  textTheme: TextTheme(
    bodySmall: TextStyle(color: lightTextColor, fontSize: 18),
    bodyMedium: TextStyle(color: lightTextColor, fontSize: 22),
    bodyLarge: TextStyle(color: lightTextColor, fontSize: 28),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      // backgroundColor: Colors.blue, // Default text color
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontSize: 14,
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      // backgroundColor: Colors.red, // Default text color
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 14,
      ),
    ),
  ),
  fontFamily: 'NunitoSans',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkPrimaryColor,
  colorScheme: ColorScheme.dark(
    primary: darkPrimaryColor,
    secondary: darkSecondaryColor,
    onPrimary: darkaccentcolor,
    tertiary: Colors.white,
    tertiaryContainer: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: darkPrimaryColor,
    titleTextStyle: TextStyle(
      color: darkaccentcolor,
      fontFamily: 'NunitoSans',
      fontSize: 35,
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(color: darkTextColor, fontSize: 18),
    bodyMedium: TextStyle(color: darkTextColor, fontSize: 22),
    bodyLarge: TextStyle(color: darkTextColor, fontSize: 28),
  ),
);
