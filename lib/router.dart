//logged out

import 'package:ensemble/features/home/screens.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/auth/screens/login_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child:LoginScreen()),
});

//logged in routes

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child:HomeScreen()),
});

