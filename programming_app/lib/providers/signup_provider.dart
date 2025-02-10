import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {

  String _username = '';
  String _email = '';
  String _password = '';

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUsername(String username){
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Getters
  String get email => _email;
  String get password => _password;
  String get username => _username;

  void clearFields() {
    _username = '';
    _email = '';
    _password = '';
    notifyListeners();
  }
}