import 'package:flutter/material.dart';

class ThemeSelect with ChangeNotifier{

  ThemeMode _thememode = ThemeMode.dark;

  get thememode => _thememode;

  toggleTheme(bool isDark){
    _thememode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}