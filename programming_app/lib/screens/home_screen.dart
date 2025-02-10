import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:programming_app/screens/chatpage.dart';
import 'package:provider/provider.dart';
import '../components/constants.dart';
import '../components/helper_widgets.dart';
import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'learnmore.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = '';
    void fetchUserId() {
      try {
        // Get the current user's UID
        User? user = FirebaseAuth.instance.currentUser;
        userId = user?.uid ?? '';

        print('$userId/////////////////////////////////');
      } catch (e) {
        print('user id is not captured');
      }
    }

    ///******* NAVIGATION PROVIDER ********
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);

    ///***** MEDIA WIDTH HEIGHT ********
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    var theme = Theme.of(context);
    String svgAsset = '';
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.currentTheme == colorfulTheme) {
      svgAsset = 'assets/images/homepic_colorful.svg';
    } else if (themeProvider.currentTheme == darkTheme) {
      svgAsset = 'assets/images/homepic.svg';
    } else if (themeProvider.currentTheme == lightTheme) {
      svgAsset = 'assets/images/homepic_light.svg';
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '  /codiefy',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.primaryColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigateToChatPage(context);
            },
            icon: const Icon(Icons.message_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Center(
          child: ListView(
            children: [
              addVerticalSpace(35),
              //heading
              Text(
                'Learn to code',
                style: theme.textTheme.displayLarge,
              ),
              addVerticalSpace(10),

              //small heading
              Text(
                'Take your first step towards \nlearning HTML, CSS',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              addVerticalSpace(10),

              //main coding pic

              SvgPicture.asset(
                svgAsset,
                width: mediaWidth,
                height: mediaWidth,
                fit: BoxFit.fitWidth,
              ),
              addVerticalSpace(20),

              //get started button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LearnMorePage()),
                  );
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Get Started  '),
                    Icon(
                      Icons.arrow_right_alt_outlined,
                    ),
                  ],
                ),
              ),

              addVerticalSpace(10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, child) {
        return BottomNavigationBar(
          currentIndex: navigationProvider.selectedIndex,
          onTap: (index) {
            navigationProvider.updateIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined), // Icon for the Learn tab
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open_rounded),
              label: "Folders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_center_focus),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }

  final UserProvider userProvider = UserProvider();

  // Navigate to ChatPage
  void navigateToChatPage(BuildContext context) {
    // Navigate to ChatPage and pass the email and ID as arguments
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          studentId: userProvider.userId,
        ),
      ),
    );
  }
}
