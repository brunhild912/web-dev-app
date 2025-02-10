import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:programming_app/screens/admin/admin_dashboard.dart';
import 'package:programming_app/screens/intializing%20screens/navigation_screen.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen while waiting for the auth state
            return Center(child: CircularProgressIndicator(color: theme.primaryColor,));
          }

          // Check if the user is logged in
          if (snapshot.hasData) {
            final user = snapshot.data!;

            // Check if the logged-in user's email is the admin email
            if (user.email == 'admin@gmail.com') {
              return const AdminDashboard(); // Navigate to admin dashboard
            } else {
              return const NavigationScreen(); // Navigate to regular user screen
            }
          } else {
            // If the user is not logged in, show the login screen
            return LoginScreen();
          }
        },
      ),
    );
  }
}
