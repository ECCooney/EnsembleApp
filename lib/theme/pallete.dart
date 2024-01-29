import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Pallete {
  // Colors
  //https://colorhunt.co/palette/eba83abb371afff8d9d5dbb3
  static const orangeCustomColor = Color.fromRGBO(235, 168, 58, 1); // primary color
  static const redCustomColor = Color.fromRGBO(187, 55, 26, 1); // secondary color
  static const drawerColor = Color.fromRGBO(255, 248, 217, 1);
  static const sageCustomColor = Color.fromRGBO(213, 219, 179, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade600;
  static var blueColor = Colors.blue.shade300;
  static var blackColor = Colors.black;
  static var greyColor = Colors.grey;

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