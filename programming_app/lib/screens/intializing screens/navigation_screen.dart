import 'package:flutter/material.dart';
import 'package:programming_app/screens/folder%20and%20files%20screens/folder_2_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import '../../providers/user_provider.dart';
import '../home_screen.dart';
import '../focus_screen.dart';
import '../user_screen.dart';
import '../w3screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///******* NAVIGATION PROVIDER ********
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String userName = userProvider.username;
    String email = userProvider.email;
    String password = userProvider.password;

    ///***** MEDIA WIDTH HEIGHT ********
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    var theme = Theme.of(context);
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (BuildContext context, navigationProvider, Widget? child) {
          return getSelectedScreen(
              navigationProvider.selectedIndex, userName, email, password);
        },
      ),
    );
  }

  Widget getSelectedScreen(
      int index, String username, String email, String password) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return const W3Screen();
      case 2:
        return const Folder2Screen();
      case 3:
        return const FocusScreen();
      default:
        return UserScreen(
          userName: username,
          userEmail: email,
          userPassword: password,
        );
    }
  }
}
