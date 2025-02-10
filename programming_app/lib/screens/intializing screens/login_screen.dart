import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:programming_app/components/helper_widgets.dart';
import 'package:programming_app/screens/intializing%20screens/navigation_screen.dart';
import 'package:programming_app/screens/intializing%20screens/signup_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/login_provider.dart';
import '../admin/admin_dashboard.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: ListView(
          children: [
            //form
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
                          'Welcome',
                          style: theme.textTheme.displayLarge?.copyWith(
                              color: theme.primaryColor, fontSize: 30),
                        ),
                        addVerticalSpace(10),
                        Text(
                          'Back',
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

                        //email
                        Consumer<LoginProvider>(
                          builder: (context, loginProvider, child) {
                            return TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                loginProvider.setEmail(value);
                              },
                              initialValue: loginProvider.email,
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
                            );
                          },
                        ),

                        //password
                        Consumer<LoginProvider>(
                          builder: (context, loginProvider, child) {
                            return TextFormField(
                              textInputAction: TextInputAction.done,
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
                                loginProvider.setPassword(value);
                              },
                              initialValue: loginProvider.password,
                            );
                          },
                        ),

                        addVerticalSpace(35),

                        ElevatedButton(
                          onPressed: () {
                            final loginProvider = Provider.of<LoginProvider>(
                                context,
                                listen: false);

                            signInUser(loginProvider.email,
                                loginProvider.password, context);

                            // Clear the text fields after submission
                            loginProvider.clearFields();
                          },
                          child: const Text('Sign in'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Not a member already?',
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //sign in firebase method
// sign in firebase method
  Future<void> signInUser(email, password, context) async {
    try {
      var navContext = Navigator.of(context);
      // Check if user exists
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check if the logged-in user's email is admin's email
      if (userCredential.user != null) {
        if (userCredential.user!.email == "admin@gmail.com") {
          // Navigate to Admin Dashboard if email matches
          navContext.push(MaterialPageRoute(
              builder: (context) =>
                  const AdminDashboard())); // Navigate to Admin Dashboard
        } else {
          // Navigate to Home Screen for students
          navContext.push(MaterialPageRoute(
              builder: (context) =>
                  const NavigationScreen())); // Navigate to Home Screen
        }
      } else {
        const snackBar = SnackBar(
          content: Text('User doesn\'t exist.'),
          duration: Duration(seconds: 2),
        );
        _globalKey.currentState?.showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
