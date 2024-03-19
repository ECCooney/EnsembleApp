// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:ensemble/theme/pallete.dart';
// import 'package:routemaster/routemaster.dart';
// import '../../../core/constants/constants.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//       const Duration(seconds: 3),
//           () {
//         Routemaster.of(context).replace('/');
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Pallete.orangeCustomColor,
//         body: Center(
//           child: Image.asset(Constants.initialWhiteLogoPath),
//         ),
//       ),
//     );
//   }
// }