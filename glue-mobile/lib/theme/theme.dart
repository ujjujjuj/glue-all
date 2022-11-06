import 'package:flutter/material.dart';

const primary = Colors.white;
const secondary = Color(0xff2C2B2B);
const tri = Color(0xffECECEC);
final theme = ThemeData.light().copyWith(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: secondary,
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: primary),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primary, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primary, width: 1),
      gapPadding: 10,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: secondary,
        fontFamily: "Proxima Nova"),
    headline2: TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: Colors.black,
    ),
    headline3: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headline4: TextStyle(
      fontSize: 20,
      fontFamily: "Proxima Nova",
      fontWeight: FontWeight.w700,
      color: secondary,
    ),
    headline5: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    headline6: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: secondary,
        fontFamily: "Proxima Nova"),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: Colors.black,
    ),
    subtitle2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.black,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.black,
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      color: Colors.black,
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.black,
    ),
    overline: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: Colors.black,
    ),
  ),
);
