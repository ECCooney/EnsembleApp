import 'package:flutter/material.dart';
import 'package:ensemble/ui/auth/register_screen.dart';
import 'package:ensemble/ui/auth/sign_in_screen.dart';
import 'package:ensemble/ui/setting/setting_screen.dart';
import 'package:ensemble/ui/splash/splash_screen.dart';
import 'package:ensemble/ui/item/create_edit_item_screen.dart';
import 'package:ensemble/ui/item/items_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String create_edit_item = '/create_edit_item';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    register: (BuildContext context) => RegisterScreen(),
    home: (BuildContext context) => ItemsScreen(),
    setting: (BuildContext context) => SettingScreen(),
    create_edit_item: (BuildContext context) => CreateEditItemScreen(),
  };
}