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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // takes an optional Key parameter, which can be used to uniquely identify this widget. The super(key: key) part calls the constructor of the superclass (StatefulWidget).

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
