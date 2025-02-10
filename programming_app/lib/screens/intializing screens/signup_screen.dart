import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:programming_app/screens/intializing%20screens/login_screen.dart';
import 'package:programming_app/screens/intializing%20screens/navigation_screen.dart';
import 'package:provider/provider.dart';
import '../../components/helper_widgets.dart';
import '../../providers/signup_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: ListView(
          children: [
            Form(
              child: Scrollbar(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        addVerticalSpace(25),
                        Text(
                          'Let\'s',
                          style: theme.textTheme.displayLarge?.copyWith(
                              color: theme.primaryColor, fontSize: 30),
                        ),
                        addVerticalSpace(10),
                        Text(
                          'Get Started',
                          style: theme.textTheme.displayLarge?.copyWith(
                              color: theme.primaryColor, fontSize: 30),
                        ),

                        addVerticalSpace(35),
                        SvgPicture.asset(
                          'assets/images/welcome.svg',
                          height: 200,
                          width: 200,
                        ),
                        addVerticalSpace(35),
                        // Username
                        Consumer<SignupProvider>(
                          builder: (context, signupProvider, child) {
                            return TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.primaryColor,
                                        width: 2.0), // Change color and width
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0), // Change color and width
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.cardColor,
                                        width: 1.0), // Change color and width
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_outline_rounded,
                                    size: 21,
                                  ),
                                  labelText: 'Name',
                                  labelStyle: theme.textTheme.labelSmall
                                      ?.copyWith(fontSize: 16)),
                              onChanged: (value) {
                                signupProvider.setUsername(value);
                              },
                              initialValue: signupProvider.username,
                            );
                          },
                        ),

                        // Email
                        Consumer<SignupProvider>(
                          builder: (context, signupProvider, child) {
                            return TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.primaryColor,
                                        width: 2.0), // Change color and width
                                  ),
                                  // Customize the underline color when the TextField is enabled but not focused
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0), // Change color and width
                                  ),
                                  // You can also customize the underline color when the TextField is disabled
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.cardColor,
                                        width: 1.0), // Change color and width
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline,
                                    size: 20,
                                  ),
                                  labelText: 'Email',
                                  labelStyle: theme.textTheme.labelSmall
                                      ?.copyWith(fontSize: 16)),
                              onChanged: (value) {
                                signupProvider.setEmail(value);
                              },
                              initialValue: signupProvider.email,
                            );
                          },
                        ),

                        // Password
                        Consumer<SignupProvider>(
                          builder: (context, signupProvider, child) {
                            return TextFormField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.primaryColor,
                                        width: 2.0), // Change color and width
                                  ),
                                  // Customize the underline color when the TextField is enabled but not focused
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0), // Change color and width
                                  ),
                                  // You can also customize the underline color when the TextField is disabled
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: theme.cardColor,
                                        width: 1.0), // Change color and width
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    size: 20,
                                  ),
                                  labelText: 'Password',
                                  labelStyle: theme.textTheme.labelSmall
                                      ?.copyWith(fontSize: 16)),
                              onChanged: (value) {
                                signupProvider.setPassword(value);
                              },
                              initialValue: signupProvider.password,
                            );
                          },
                        ),

                        addVerticalSpace(25),
                        ElevatedButton(
                          onPressed: () {
                            final signupProvider = Provider.of<SignupProvider>(
                                context,
                                listen: false);

                            // Attempt to sign up
                            signUp(
                                signupProvider.email,
                                signupProvider.password,
                                signupProvider.username,
                                context);

                            // Clear the text fields after submission
                            signupProvider.clearFields();
                          },
                          child: const Text('Sign up'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Sign in',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password, String userName,
      BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Email and password must not be empty.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? uid = getCurrentUserId();
      addUserInfoToFirebase(email, password, userName, uid!);

      // Navigate to home screen after sign-up
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const NavigationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign Up Failed'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      print(errorMessage);
    } catch (e) {
      // Handle any other errors
      print('Unexpected error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('An unexpected error occurred. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> addUserInfoToFirebase(
      String email, String password, String userName, String uid) async {
    String? userId = getCurrentUserId();
    var db = FirebaseFirestore.instance;
    final userInfo = <String, String>{
      "username": userName,
      "email": email,
      "password": password,
      "uid": uid,
    };
    db
        .collection('users')
        .doc(userId)
        .set(userInfo)
        .onError((e, _) => print("Error writing document: $e"));
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    return user?.uid; // Return the user's ID (uid) or null if not authenticated
  }
}
