import 'package:flutter/material.dart';
import 'package:fortuna/core/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

final TextTheme _baseTextTheme = GoogleFonts.robotoTextTheme().apply(
  bodyColor: Colors.white,
  displayColor: Colors.white,
);

final darkTheme = ThemeData(

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: MyColors.grey3,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: MyColors.grey4, width: 3),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: MyColors.grey4),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: MyColors.myYellowColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
    ),
    errorStyle: TextStyle(height: 0, fontSize: 0),
  ),
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.roboto().fontFamily,
  scaffoldBackgroundColor: MyColors.myBackgroundColor,
  colorScheme: ColorScheme.dark(
    surface: MyColors.grey2,
    primary: MyColors.myYellowColor,
    onPrimary: Colors.black,
    onSurface: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.myYellowColor,
    foregroundColor: Colors.black,
    titleTextStyle: GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: MyColors.grey2,
    surfaceTintColor: MyColors.grey2,
    height: 104,
    indicatorShape: Border(),
  ),
  textTheme: _baseTextTheme.copyWith(
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineLarge: GoogleFonts.roboto(
      
      fontSize: 44,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: MyColors.myYellowColor,
    ),
    displayLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: MyColors.myYellowColor,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.roboto(
      height: 1.5, 
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
);
