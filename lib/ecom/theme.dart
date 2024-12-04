import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black)),
  cardColor: Colors.white,
  cardTheme: const CardTheme(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  // textTheme: const TextTheme(
  //   headline6: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
  //   bodyText1: TextStyle(color: Colors.black87, fontSize: 16),
  //   bodyText2: TextStyle(color: Colors.black54, fontSize: 14),
  // ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.deepPurple,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white70,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.deepPurple),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurpleAccent,

  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white)),
  // cardColor: Colors.red[850], // Distinct card color
  cardTheme: const CardTheme(
    elevation: 10,
    color: Colors.black26,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shadowColor: Colors.black87,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  // textTheme: const TextTheme(
  //   headline6: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  //   bodyText1: TextStyle(color: Colors.white70, fontSize: 16),
  //   bodyText2: TextStyle(color: Colors.white60, fontSize: 14),
  // ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.deepPurpleAccent,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.deepPurpleAccent),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
    ),
  ),
);
