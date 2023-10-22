import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primarySwatch: const MaterialColor(
      0xFFE0E0E0, // Set the primary color to white
      <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEAEAEA),
        300: Color(0xFFE0E0E0),
        400: Color(0xFFD6D6D6),
        500: Color(0xFFCCCCCC),
        600: Color(0xFFC2C2C2),
        700: Color(0xFFB8B8B8),
        800: Color(0xFFADADAD),
        900: Color(0xFFA3A3A3),
      },
    ),
    primaryColorLight: const Color.fromARGB(223, 211, 212, 217),
    primaryColorDark: const Color.fromARGB(255, 131, 130, 128),
    canvasColor: const Color.fromARGB(255, 243, 240, 236),
    scaffoldBackgroundColor: const Color.fromARGB(224, 255, 249, 251),
    dividerColor: const Color.fromARGB(231, 76, 91, 97),
    focusColor: const Color.fromARGB(224, 37, 38, 39),
    splashColor: const Color.fromARGB(224, 37, 38, 39),
    cardColor: const Color.fromARGB(255, 145, 151, 174),
    highlightColor: const Color.fromARGB(255, 108, 145, 194),
    // cardColor: const Color.fromARGB(255, 240, 45, 58),
    // textTheme: TextTheme(
    //     titleSmall: GoogleFonts.poppins(
    //         color: const Color.fromARGB(255, 145, 151, 174),
    //         textStyle: const TextStyle(overflow: TextOverflow.ellipsis)),
    //     titleMedium: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 145, 151, 174),
    //     ),
    //     titleLarge: GoogleFonts.russoOne(
    //       color: const Color.fromARGB(255, 76, 91, 97),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 25.r),
    //     ),
    //     headlineLarge: GoogleFonts.russoOne(
    //       color: const Color.fromARGB(255, 243, 240, 236),
    //       textStyle: TextStyle(
    //         overflow: TextOverflow.ellipsis,
    //         fontSize: 25.r,
    //         color: const Color.fromARGB(255, 243, 240, 236),
    //       ),
    //     ),
    //     headlineSmall: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 37, 38, 39),
    //       textStyle: TextStyle(
    //         overflow: TextOverflow.ellipsis,
    //         fontSize: 14.r,
    //         color: const Color.fromARGB(255, 37, 38, 39),
    //       ),
    //     ),
    //     subtitle1: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 145, 151, 174),
    //       textStyle: TextStyle(
    //         overflow: TextOverflow.ellipsis,
    //         fontSize: 12.r,
    //         color: const Color.fromARGB(255, 145, 151, 174),
    //       ),
    //     ),
    //     caption: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 145, 151, 174),
    //       textStyle: TextStyle(
    //         overflow: TextOverflow.ellipsis,
    //         fontSize: 12.r,
    //         color: const Color.fromARGB(255, 145, 151, 174),
    //       ),
    //     ),
    //     displayLarge: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 253, 191, 6),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16.r),
    //     )),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 145, 151, 174),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primarySwatch: const MaterialColor(
      0xFFE0E0E0, // Set the primary color to white
      <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEAEAEA),
        300: Color(0xFFE0E0E0),
        400: Color(0xFFD6D6D6),
        500: Color(0xFFCCCCCC),
        600: Color(0xFFC2C2C2),
        700: Color(0xFFB8B8B8),
        800: Color(0xFFADADAD),
        900: Color(0xFFA3A3A3),
      },
    ),
    primaryColorLight: const Color.fromARGB(223, 48, 56, 74),
    primaryColorDark: const Color.fromARGB(255, 131, 130, 128),
    canvasColor: const Color.fromARGB(255, 243, 240, 236),
    scaffoldBackgroundColor: const Color.fromARGB(224, 39, 48, 67),
    dividerColor: const Color.fromARGB(231, 4, 4, 4),
    focusColor: const Color.fromARGB(255, 255, 249, 251),
    splashColor: const Color.fromARGB(224, 37, 38, 39),
    cardColor: const Color.fromARGB(255, 145, 151, 174),
    highlightColor: const Color.fromARGB(255, 108, 145, 194),
    // cardColor: const Color.fromARGB(255, 240, 45, 58),
    // textTheme: TextTheme(
    // titleSmall: GoogleFonts.poppins(
    //     color: const Color.fromARGB(255, 39, 48, 67),
    //     textStyle: const TextStyle(overflow: TextOverflow.ellipsis)),
    //     titleMedium: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 145, 151, 174),
    //     ),
    //     titleLarge: GoogleFonts.russoOne(
    //       color: const Color.fromARGB(255, 243, 240, 236),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 25.r),
    //     ),
    //     bodyLarge: GoogleFonts.russoOne(
    //       color: const Color.fromARGB(255, 243, 240, 236),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 25.r),
    //     ),
    //     labelLarge: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 243, 240, 236),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14.r),
    //     ),
    //     bodySmall: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 145, 151, 174),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12.r),
    //     ),
    //     displayLarge: GoogleFonts.poppins(
    //       color: const Color.fromARGB(255, 253, 191, 6),
    //       textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16.r),
    //     )),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 145, 151, 174),
    ),
  );
}
