import 'package:flutter/material.dart';

Color lightPrimaryColor = Color.fromARGB(255, 255, 255, 255);
Color lightSecondaryColor = Color.fromARGB(255, 236, 236, 236);
Color lightTextColor = Colors.black;
Color lightaccentColor = const Color.fromARGB(255, 255, 255, 255);
Color lightteritarycontainer = Color.fromARGB(255, 235, 235, 235);

Color darkPrimaryColor = const Color(0xFF121212);
Color darkSecondaryColor = const Color(0xff1b1b1b);
Color darkTextColor = const Color(0xFFF0F3FF);
Color darkaccentcolor = const Color(0xFF6CCEFF);
Color darkteritarycontainer = Colors.black;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: lightPrimaryColor,
    secondary: lightSecondaryColor,
    onPrimary: lightaccentColor,
    tertiary: Colors.black,
    tertiaryContainer: lightteritarycontainer,
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
    tertiaryContainer: darkteritarycontainer,
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
