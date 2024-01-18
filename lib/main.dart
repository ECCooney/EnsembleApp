import 'package:ensemble/pages/auth/login_page.dart';
import 'package:ensemble/helper/helper_function.dart';
import 'package:ensemble/pages/home_page.dart';
import 'package:ensemble/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized(); //ensure all Widgets are initilised
 if (kIsWeb){
   //run the initialisation for web
   await Firebase.initializeApp(
       options: FirebaseOptions
         (apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId));
 }
 else{
   //run intialization for android/iOs
   await Firebase.initializeApp(); //initialises Anroid and IoS if no options provided
 }

 runApp(const MyApp());

}

final db = FirebaseFirestore.instance;
String? value;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignedIn = false; //underscore in dart means the varible is private to it's library
 // takes an optional Key parameter, which can be used to uniquely identify this widget. The super(key: key) part calls the constructor of the superclass (StatefulWidget).
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value!=null){
        _isSignedIn = value;

      }
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      //if isSignedIn = True show Homepage, else show LoginPage
      home: _isSignedIn ? HomePage() : LoginPage(),
    );
  }
}
