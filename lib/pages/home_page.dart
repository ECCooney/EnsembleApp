import 'package:ensemble/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  AuthService authService = AuthService();//a private class _HomePageState that extends State<HomePage>. It represents the mutable state for the HomePage widget.
  @override
  Widget build(BuildContext context) {
 // In Flutter, a Scaffold is a basic material design visual layout structure.
  // It provides a top app bar, a body, and a bottom navigation bar.
  // In this case, the Scaffold is empty, and you would typically add various widgets to the body property to define the content of the homepage.
  return Scaffold(
      body: Center(child:ElevatedButton(child: const Text("Log Out"), onPressed:(){
        authService.signout();
      },
      )),
  );
  }
}
