import 'package:flutter/material.dart';

// Dark Theme Colors
const kDarkBackgroundColor = Color(0xff221F2E);
const kDarkContainerColor = Color(0xff2E2B3F);
const kDarkHeadingColor = Color(0xffe9e8ea);
const kDarkTextColor = Color(0xffadb8bb);
const kDarkAccentColor = Color(0xff7961F1);
const kDarkLabelSmallColor = Color(0xff8A8A8D);

// Light Theme Colors (Navy Scheme)
const kLightBackgroundColor = Color(0xffffffff);
const kLightContainerColor = Color(0xffF0F4F8);
const kLightHeadingColor = Color(0xff1A1A2E);
const kLightTextColor = Color(0xff2C3E50);
const kLightAccentColor = Color(0xff2e8bc0);
const kLightLabelSmallColor = Color(0xff5D737E);

/// Colorful Theme Colors (Modern Pastel)
const kColorfulBackgroundColor = Color(0xffF7F3E9); // Light Ivory
const kColorfulContainerColor = Color(0xffE8E1EF); // Soft Lavender
const kColorfulHeadingColor = Color(0xff8E7CC3); // Vibrant Lilac
const kColorfulTextColor = Color(0xffD4A5A5); // Rose Quartz
const kColorfulAccentColor = Color(0xffF9A875); // Soft Gold
const kColorfulLabelSmallColor = Color(0xffA3C4BC); // Seafoam Green
const kColorfulComplementaryAccentColor = Color(0xff6AA9E6); // Sky Blue

//theme data for my color schemes
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBackgroundColor,
  primaryColor: kDarkAccentColor,
  appBarTheme: const AppBarTheme(
    color: kDarkContainerColor,
    titleTextStyle: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: kDarkHeadingColor,
      fontFamily: 'Roboto',
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: kDarkHeadingColor,
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: kDarkTextColor,
      fontFamily: 'inriaR',
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: kDarkLabelSmallColor,
      fontFamily: 'inriaR',
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(50, 50),
      iconColor: kDarkHeadingColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Border radius of 5
      ),
      foregroundColor: kDarkHeadingColor,
      backgroundColor: kDarkAccentColor, // Button text color
      textStyle: const TextStyle(
        fontFamily: 'inriaR',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: kDarkTextColor),
  cardColor: kDarkContainerColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kDarkContainerColor,
    selectedItemColor: kDarkAccentColor, // Color of the selected item
    unselectedItemColor: kDarkTextColor, // Color of the unselected items
    selectedIconTheme: IconThemeData(color: kDarkAccentColor),
    unselectedIconTheme: IconThemeData(color: kDarkTextColor),
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kDarkAccentColor,
    selectionColor: kDarkAccentColor.withOpacity(0.5),
    selectionHandleColor: kDarkAccentColor.withOpacity(0.5),
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kLightBackgroundColor,
  primaryColor: kLightAccentColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kLightAccentColor,
    selectionColor: kLightAccentColor.withOpacity(0.5),
    selectionHandleColor: kLightAccentColor.withOpacity(0.5),
  ),
  appBarTheme: const AppBarTheme(
    color: kLightContainerColor,
    titleTextStyle: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: kLightHeadingColor,
      fontFamily: 'Roboto',
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: kLightHeadingColor,
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: kLightTextColor,
      fontFamily: 'inriaR',
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: kLightLabelSmallColor,
      fontFamily: 'inriaR',
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(50, 50),
      iconColor: kLightBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Border radius of 5
      ),
      foregroundColor: kLightBackgroundColor,
      backgroundColor: kLightAccentColor, // Button text color
      textStyle: const TextStyle(
        fontFamily: 'inriaR',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: kLightContainerColor),
  cardColor: kLightContainerColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kLightContainerColor,
    selectedItemColor: kLightAccentColor,
    unselectedItemColor: kLightTextColor,
    selectedIconTheme: IconThemeData(color: kLightAccentColor),
    unselectedIconTheme: IconThemeData(color: kLightTextColor),
    showSelectedLabels: true, // Show labels for selected items
    showUnselectedLabels: true, // Show labels for unselected items
  ),
);

final ThemeData colorfulTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kColorfulBackgroundColor,
  primaryColor: kColorfulAccentColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kColorfulAccentColor,
    selectionColor: kColorfulAccentColor.withOpacity(0.5),
    selectionHandleColor: kColorfulAccentColor.withOpacity(0.5),
  ),
  appBarTheme: const AppBarTheme(
    color: kColorfulContainerColor,
    titleTextStyle: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: kColorfulHeadingColor,
      fontFamily: 'Roboto',
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: kColorfulHeadingColor,
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: kColorfulTextColor,
      fontFamily: 'inriaR',
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: kColorfulLabelSmallColor,
      fontFamily: 'inriaR',
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(50, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Border radius of 5
      ),
      iconColor: kColorfulBackgroundColor,
      foregroundColor: kColorfulBackgroundColor,
      backgroundColor: kColorfulAccentColor, // Button text color
      textStyle: const TextStyle(
        fontFamily: 'inriaR',
        fontSize: 16.0,
        fontWeight: FontWeight.w900,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: kColorfulComplementaryAccentColor),
  cardColor: kColorfulContainerColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor:
        kColorfulBackgroundColor, // Background color of the BottomNavigationBar
    selectedItemColor: kColorfulAccentColor, // Color of the selected item
    unselectedItemColor:
        kColorfulComplementaryAccentColor, // Color of the unselected items
    selectedIconTheme: IconThemeData(color: kColorfulAccentColor),
    unselectedIconTheme:
        IconThemeData(color: kColorfulComplementaryAccentColor),
    showSelectedLabels: true, // Show labels for selected items
    showUnselectedLabels: true, // Show labels for unselected items
  ),
);

/// ****************CODE FIELD COLORS***********************
// Dark Theme CodeField Colors
const kDarkCodeFieldBackground = Color(0xff1a1b26); // Dark Navy-Black
const kDarkCodeFieldTextColor = Color(0xffc0caf5); // Soft Blue for Text

// Light Theme CodeField Colors
const kLightCodeFieldBackground = Color(0xffffffff); // White Background
const kLightCodeFieldTextColor = Color(0xff2c3e50); // Dark Blue-Gray Text

// Colorful Theme CodeField Colors
const kColorfulCodeFieldBackground = Color(0xfff7f3e9); // Soft Cream Background
const kColorfulCodeFieldTextColor =
    Color(0xff8e7cc3); // Purple for General Text

const String kCodeFontFamily = 'monospace'; // Shared Monospace Font
