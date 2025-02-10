import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  String _email = '';
  String _password = '';

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Getters
  String get email => _email;
  String get password => _password;

  void clearFields() {
    _email = '';
    _password = '';
    notifyListeners();
  }
}