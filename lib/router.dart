//logged out

import 'package:ensemble/features/group/screens/admin_tools_screen.dart';
import 'package:ensemble/features/group/screens/create_group_screen.dart';
import 'package:ensemble/features/group/screens/edit_group_screen.dart';
import 'package:ensemble/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/group/screens/group_screen.dart';
import 'features/item/screens/create_item_screen.dart';
import 'features/item/screens/item_screen.dart';
import 'features/user/screens/edit_profile_screen.dart';
import 'features/user/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child:LoginScreen()),
  '/register': (_) => const MaterialPage(child: RegisterScreen()),
});

//logged in routes

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child:HomeScreen()),
  '/create-group': (_) => const MaterialPage(child: CreateGroupScreen()),
  '/admin-tools/:id': (routeData) => MaterialPage(child: AdminToolsScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/create-item/:id': (routeData) => MaterialPage(child: CreateItemScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/edit-group/:id': (routeData) => MaterialPage(child: EditGroupScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/:id' : (route) => MaterialPage(
      child: GroupScreen(
        id: route.pathParameters['id']!,
  )),
  '/item/:id' : (route) => MaterialPage(
      child: ItemScreen(
        id: route.pathParameters['id']!,
      )),

  '/user/:uid': (routeData) => MaterialPage(
    child: UserProfileScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
    child: EditProfileScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
});

