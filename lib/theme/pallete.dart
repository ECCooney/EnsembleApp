import 'package:flutter/material.dart';
class Pallete {
  // Colors
  //https://colorhunt.co/palette/eba83abb371afff8d9d5dbb3
  static const orangeCustomColor = Color.fromRGBO(240, 95, 64, 1); // primary color
  static const orangeCustomColorTransp = Color.fromRGBO(240, 95, 64, 0.7); // primary color
  static const redCustomColor = Color.fromRGBO(187, 55, 26, 1); // secondary color
  static const drawerColor = Colors.white70;
  static const whiteFaded = Color.fromRGBO(255, 255, 255, 0.7);
  static const whiteColor = Colors.white;
  static var  redColor = Colors.red.shade600;
  static var  blueColor = Colors.blue.shade700;
  static const  blackColor = Colors.black;
  static const  greyColor = Colors.grey;

  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    backgroundColor: drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: orangeCustomColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    backgroundColor: whiteColor,
  );

  static const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black), //if border is clicked
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2)
    ),
    enabledBorder: OutlineInputBorder( //if border is not clicked
        borderSide: BorderSide(color: Color(0xFFee7b64), width: 2)
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)
    ),
  );


}