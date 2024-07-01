import 'package:flutter/material.dart';

Color primarycolor = Color(0xFFF0F3FF);
Color secondarycolor = Color.fromARGB(255, 18, 18, 18);

Color accentcolor = Colors.blue;

ThemeData lightTheme = ThemeData(
  primaryColor: primarycolor,
  fontFamily: 'NunitoSans_7pt',
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 237, 244, 255),
    titleTextStyle: TextStyle(
        color: accentcolor, fontFamily: 'NunitoSans_7pt', fontSize: 20),
  ),
  scaffoldBackgroundColor: primarycolor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: accentcolor,
    extendedTextStyle: TextStyle(color: primarycolor),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(color: secondarycolor, fontSize: 18),
    bodyMedium: TextStyle(color: secondarycolor, fontSize: 22),
    bodyLarge: TextStyle(color: secondarycolor, fontSize: 28),
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: primarycolor,
  fontFamily: 'NunitoSans_7pt',
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: secondarycolor,
    titleTextStyle: TextStyle(
        color: accentcolor, fontFamily: 'NunitoSans_7pt', fontSize: 35),
  ),
  scaffoldBackgroundColor: secondarycolor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: accentcolor,
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(color: primarycolor, fontSize: 18),
    bodyMedium: TextStyle(color: primarycolor, fontSize: 22),
    bodyLarge: TextStyle(color: primarycolor, fontSize: 28),
  ),
);
