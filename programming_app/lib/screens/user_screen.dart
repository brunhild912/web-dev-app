import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/constants.dart';
import '../components/helper_widgets.dart';
import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import 'intializing screens/login_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.userPassword});

  final String userName;
  final String userEmail;
  final String userPassword;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _HTMLStructureTipisExpanded = false;
  bool _CSSFlexboxTipisExpanded = false;
  bool _ResponsiveDesignTipisExpanded = false;
  bool _CSSTransitionTipisExpanded = false;
  String tips = "";

  String HTMLStructureTip = 'Always use semantic HTML elements to '
      'improve accessibility and SEO. Elements like <header>, <footer>, <article>, and'
      ' <nav> provide meaning to your content, making it easier for'
      'browsers and search engines to understand the structure of your web page.';

  String CSSFlexboxTip = 'Utilize CSS Flexbox'
      ' for responsive layouts. Flexbox allows you to easily align and distribute '
      'space among items in a container, adapting to different screen sizes without the need for complex calculations.';

  String ResponsiveDesignTip = 'Always use relative units'
      ' (like percentages, em, and rem) for padding, margins, and font sizes to '
      'ensure your design is responsive and adjusts to various screen sizes.';

  String CSSTransitionTip = 'Add CSS transitions '
      'for a smoother user experience. By defining transition properties, '
      'you can create animations that enhance interactivity without compromising performance.';

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName;
    String email = widget.userEmail;
    String password = widget.userPassword;

    var theme = Theme.of(context);
    double mediaWidth = MediaQuery.sizeOf(context).width;

    ///********** user info ********
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(20),
              Text(
                'Your Profile Information',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.displayLarge?.color,
                ),
              ),
              addVerticalSpace(10),
              //add user profile here
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $userName'),
                    Text('Email: $email'),
                    Text('Password: $password'),
                  ],
                ),
              ),
              addVerticalSpace(35),
              Text(
                'Color Schemes',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.displayLarge?.color,
                ),
              ),
              addVerticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColorSchemeContainer(
                      "Light Theme",
                      Icons.light_mode_outlined,
                      mediaWidth,
                      context,
                      theme,
                      lightTheme),
                  _buildColorSchemeContainer(
                      "Dark Theme",
                      Icons.nightlight_outlined,
                      mediaWidth,
                      context,
                      theme,
                      darkTheme),
                  _buildColorSchemeContainer(
                      "Colorful Theme",
                      Icons.palette_outlined,
                      mediaWidth,
                      context,
                      theme,
                      colorfulTheme),
                ],
              ),
              addVerticalSpace(35),
              Text(
                'HTML & CSS Tips',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.displayLarge?.color,
                ),
              ),
              buildTipsContainer(
                  theme,
                  "HTML CSS Structure Tip",
                  HTMLStructureTip,
                  HTMLStructureTip,
                  _HTMLStructureTipisExpanded, () {
                setState(() {
                  _HTMLStructureTipisExpanded = !_HTMLStructureTipisExpanded;
                });
              }),
              addVerticalSpace(5),
              buildTipsContainer(theme, "CSS FlexBox Tip", CSSFlexboxTip,
                  CSSFlexboxTip, _CSSFlexboxTipisExpanded, () {
                setState(() {
                  _CSSFlexboxTipisExpanded = !_CSSFlexboxTipisExpanded;
                });
              }),
              addVerticalSpace(5),
              buildTipsContainer(
                  theme,
                  "Responsive Design Tip",
                  ResponsiveDesignTip,
                  ResponsiveDesignTip,
                  _ResponsiveDesignTipisExpanded, () {
                setState(() {
                  _ResponsiveDesignTipisExpanded =
                      !_ResponsiveDesignTipisExpanded;
                });
              }),
              addVerticalSpace(5),
              buildTipsContainer(theme, "CSS Transition Tip", CSSTransitionTip,
                  CSSTransitionTip, _CSSTransitionTipisExpanded, () {
                setState(() {
                  _CSSTransitionTipisExpanded = !_CSSTransitionTipisExpanded;
                });
              }),

              addVerticalSpace(35),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .signOut(); // Sign out from Firebase
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } catch (e) {
                    // Handle any errors during sign out
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                child: const Text('Log out'),
              ),
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

  Container buildTipsContainer(ThemeData theme, String heading, String tip,
      String tip2, bool boolState, VoidCallback onToggle) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 0, bottom: 0, right: 0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              heading,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: IconButton(
                color: theme.primaryColor,
                icon: Icon(boolState ? Icons.expand_less : Icons.expand_more),
                onPressed: onToggle,
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tip.split(" ").take(10).join(" "),
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 14),
              ),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tip2,
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 14),
              ),
            ),
            crossFadeState: boolState
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSchemeContainer(String schemeName, IconData icon,
      double width, BuildContext context, var theme, ThemeData themeName) {
    return GestureDetector(
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false).setTheme(themeName);
        print("Selected Color Scheme: $schemeName");
      },
      child: Container(
        height: width / 3.5,
        width: width / 3.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: theme.scaffoldBackgroundColor,
              ),
              child: Icon(icon, color: theme.primaryColor),
            ),
            const SizedBox(height: 5),
            Text(
              schemeName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
