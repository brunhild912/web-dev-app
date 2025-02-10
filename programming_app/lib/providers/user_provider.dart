import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String _username = "Loading...";
  String _email = "xyz@gmail.com";
  String _password = "1234";
  String _userId = '0000';

  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get userId => _userId;

  UserProvider() {
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      _userId = user?.uid ?? '';

      if (_userId.isNotEmpty) {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

        // Update the username and notify listeners
        if (userDoc.exists) {
          _username = userDoc['username'];
          _email = userDoc['email'];
          _password = userDoc['password'];
        } else {
          _username = "Loading...";
         _email = "xyz@gmail.com";
          _password = "1234";
        }
      } else {
        _username = "No user signed in";
      }
      notifyListeners();
    } catch (e) {
      _username = "Error fetching user info";
      notifyListeners();
      print("Failed to fetch user info: $e");
    }
  }
}
