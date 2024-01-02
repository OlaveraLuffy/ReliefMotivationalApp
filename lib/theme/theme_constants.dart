import 'package:flutter/material.dart';

const Color canvasColor = Color(0xfffcfae0);
const Color colorPrimary = Color(0xff889e55);
const Color colorPrimaryHalfTransparent = Color(0x88889e55);
const Color colorPrimaryDark = Color(0xff364b22);
const Color colorPrimaryDarkHalfTransparent = Color(0x88364b22);
const Color colorSecondaryDark = Color(0xff9d6125);
const Color colorAccent = Color(0xffb9712a);

ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: canvasColor,
      secondary: colorPrimaryDark,
      background: canvasColor,
      onBackground: colorSecondaryDark,
      primaryContainer: colorPrimary,
      onPrimaryContainer: canvasColor,
      shadow: colorSecondaryDark,
      tertiary: colorPrimaryDarkHalfTransparent,
    ),
    canvasColor: canvasColor,
    primaryColorDark: colorPrimaryDark,
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: canvasColor,
    appBarTheme: const AppBarTheme(
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: colorSecondaryDark)),
    timePickerTheme: const TimePickerThemeData(
        backgroundColor: colorPrimary,
        dialTextColor: colorPrimaryDark,
        dialBackgroundColor: canvasColor,
        dialHandColor: colorPrimaryHalfTransparent,
        hourMinuteColor: canvasColor,
        hourMinuteTextColor: colorPrimaryDark,
        entryModeIconColor: canvasColor),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
          color: colorPrimary,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      titleMedium: TextStyle(
          color: colorPrimary,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      titleLarge: TextStyle(
          color: colorPrimary,
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      labelSmall: TextStyle(
          color: canvasColor,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      labelMedium: TextStyle(
          color: canvasColor,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      displayMedium: TextStyle(
          color: colorPrimaryDark,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      displayLarge: TextStyle(
          color: colorPrimaryDark,
          fontSize: 38.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      labelLarge: TextStyle(
          color: canvasColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
      bodySmall:
          TextStyle(color: canvasColor, fontSize: 18.0, fontFamily: 'Nunito'),
      bodyMedium:
          TextStyle(color: canvasColor, fontSize: 24.0, fontFamily: 'Nunito'),
      bodyLarge:
          TextStyle(color: canvasColor, fontSize: 28.0, fontFamily: 'Nunito'),
    ),
    iconTheme: const IconThemeData(
      color: canvasColor,
    ),
    dividerTheme: const DividerThemeData(
      color: canvasColor,
      space: 20.0,
      thickness: 2.5,
    ),
    cardTheme: CardTheme(
        elevation: 0.0,
        color: colorPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
      textStyle: MaterialStateProperty.all(const TextStyle(
        color: canvasColor,
        fontSize: 28,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
      )),
      backgroundColor: MaterialStateProperty.all(colorPrimary),
    )));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
