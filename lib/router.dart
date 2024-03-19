//logged out

import 'package:ensemble/features/booking/screens/booking_requests.dart';
import 'package:ensemble/features/admin/screens/admin_messages_screen.dart';
import 'package:ensemble/features/admin/screens/admin_tools_screen.dart';
import 'package:ensemble/features/group/screens/create_group_screen.dart';
import 'package:ensemble/features/group/screens/edit_group_screen.dart';
import 'package:ensemble/features/home/screens/home_screen.dart';
import 'package:ensemble/features/message/screens/message_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/booking/screens/booking_details.dart';
import 'features/booking/screens/bookings.dart';
import 'features/admin/screens/add_admins_screen.dart';
import 'features/group/screens/group_screen.dart';
import 'features/group/screens/join_group.dart';
import 'features/item/screens/create_item_screen.dart';
import 'features/item/screens/edit_item_screen.dart';
import 'features/item/screens/item_screen.dart';
import 'features/message/screens/message_admins_screen.dart';
import 'features/message/screens/message_responses_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/user/screens/edit_profile_screen.dart';
import 'features/user/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child:LoginScreen()),
  // '/splash': (_) => const MaterialPage(child:SplashScreen()),
  '/register': (_) => const MaterialPage(child: RegisterScreen()),
});

//logged in routes

final loggedInRoute = RouteMap(routes: {
  //home
  '/': (_) => const MaterialPage(child:HomeScreen()),

  //groups
  '/create-group': (_) => const MaterialPage(child: CreateGroupScreen()),
  '/edit-group/:id': (routeData) => MaterialPage(child: EditGroupScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/join-group/:id': (routeData) => MaterialPage(child: JoinGroupScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/message-admins/:id': (routeData) => MaterialPage(child: MessageAdminsScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/:id' : (route) => MaterialPage(
      child: GroupScreen(
        id: route.pathParameters['id']!,
      )),

  //admin
  '/admin-tools/:id': (routeData) => MaterialPage(child: AdminToolsScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/add-admins/:id': (routeData) => MaterialPage(
    child: AddAdminsScreen(
      id: routeData.pathParameters['id']!,
    ),
  ),
  '/view-messages/:id': (routeData) => MaterialPage(
    child: AdminMessagesScreen(
      id: routeData.pathParameters['id']!,
    ),
  ),
  '/message-details/:id': (routeData) => MaterialPage(
    child: MessageDetailsScreen(
      id: routeData.pathParameters['id']!,
    ),
  ),


  //item
  '/create-item/:id': (routeData) => MaterialPage(child: CreateItemScreen(
    id: routeData.pathParameters['id']!,
  )),
  '/item/:id' : (route) => MaterialPage(
      child: ItemScreen(
        id: route.pathParameters['id']!,
      )),
  '/edit-item/:id': (routeData) => MaterialPage(child: EditItemScreen(
    id: routeData.pathParameters['id']!,
  )),

  //user
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
  '/responses/:uid': (routeData) => MaterialPage(
    child: MessageResponsesScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),

  //bookings

  '/booking-requests/:uid': (routeData) => MaterialPage(
    child: BookingRequests(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
  '/booking-request-details/:id': (routeData) => MaterialPage(
    child: BookingRequests(
      uid: routeData.pathParameters['id']!,
    ),
  ),
  '/bookings/:uid': (routeData) => MaterialPage(
    child: BookingsScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
  '/booking-details/:id': (routeData) => MaterialPage(
    child: BookingDetails(
      id: routeData.pathParameters['id']!,
    ),
  ),

});

