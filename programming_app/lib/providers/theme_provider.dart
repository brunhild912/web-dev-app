import 'package:flutter/material.dart';
import '../components/constants.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _currentTheme = lightTheme;
  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  Color get codeFieldBackground {
    if (_currentTheme.brightness == Brightness.dark) {
      return kDarkCodeFieldBackground;
    } else if (_currentTheme.brightness == Brightness.light) {
      return kLightCodeFieldBackground;
    } else {
      return kColorfulCodeFieldBackground; // Default for colorful theme
    }
  }

  Color get codeFieldTextColor {
    if (_currentTheme.brightness == Brightness.dark) {
      return kDarkCodeFieldTextColor;
    } else if (_currentTheme.brightness == Brightness.light) {
      return kLightCodeFieldTextColor;
    } else {
      return kColorfulCodeFieldTextColor; // Default for colorful theme
    }
  }

}