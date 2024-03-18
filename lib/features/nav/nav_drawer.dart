import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:ensemble/theme/pallete.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({Key? key});

  void navigateToCreateGroup(BuildContext context) {
    Routemaster.of(context).push('/create-group');
  }

  void navigateToRequests(BuildContext context, String uid) {
    Routemaster.of(context).push('/booking-requests/$uid');
  }

  void navigateToHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  void navigateToBookings(BuildContext context, String uid) {
    Routemaster.of(context).push('/bookings/$uid');
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user/$uid');
  }

  void navigateToMessageResponses(BuildContext context, String uid) {
    Routemaster.of(context).push('/responses/$uid');
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 230,
              child: DrawerHeader(
                decoration: const BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [Pallete.orangeCustomColor, Colors.black],
              ),
        ),
                    child: GestureDetector(
                      onTap: () => navigateToUserProfile(context, user.uid),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                         CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: NetworkImage(user!.profilePic),
                                ),
                              // onPressed:(){navigateToUserProfile(context, user.uid);},
                          SizedBox(height: 10),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
              ),
            ),
            ListTile(
              onTap: () => navigateToHome(context),
              leading: Icon(Icons.group, color: Pallete.orangeCustomColor),
              title: const Text(
                "Groups",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () => navigateToUserProfile(context, user.uid),
              leading: Icon(Icons.person, color: Pallete.orangeCustomColor),
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () => navigateToCreateGroup(context),
              leading: const Icon(Icons.add, color: Pallete.orangeCustomColor),
              title: const Text(
                "Create a New Group",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () => navigateToRequests(context, user.uid),
              leading: const Icon(Icons.question_answer, color: Pallete.orangeCustomColor),
              title: const Text(
                "Requests",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () => navigateToBookings(context, user.uid),
              leading: const Icon(Icons.calendar_month, color: Pallete.orangeCustomColor),
              title: const Text(
                "Bookings",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () => navigateToMessageResponses(context, user.uid),
              leading: const Icon(Icons.message, color: Pallete.orangeCustomColor),
              title: const Text(
                "Message Responses",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Spacer(),
            Divider(color: Pallete.orangeCustomColor),
            ListTile(
              onTap: () {
                logOut(ref);
                navigateToHome(context);
              },
              leading: Icon(Icons.exit_to_app, color: Pallete.orangeCustomColor),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            //removed function for pop up as couldn't get it to automatically disappear
            // ListTile(
            //   onTap: () async {
            //     showDialog(
            //       barrierDismissible: false,
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           title: Text("Logout"),
            //           content: Text("Are you sure you want to logout?"),
            //           actions: [
            //             IconButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //               icon: Icon(Icons.cancel, color: Pallete.redCustomColor),
            //             ),
            //             IconButton(
            //               onPressed: () async {
            //                 logOut(ref);
            //                navigateToHome(context);
            //               },
            //               icon: Icon(Icons.done, color: Colors.green),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            //   leading: Icon(Icons.exit_to_app, color: Pallete.orangeCustomColor),
            //   title: Text(
            //     "Logout",
            //     style: TextStyle(fontSize: 16, color: Colors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}