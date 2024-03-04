import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:ensemble/theme/pallete.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({super.key});

  void navigateToCreateGroup(BuildContext context){
    Routemaster.of(context).push('/create-group');
  }

  void navigateToRequests(BuildContext context, String uid){
    Routemaster.of(context).push('/booking-requests/$uid');
  }

  void navigateToHome(BuildContext context){
    Routemaster.of(context).push('/');
  }

  void navigateToBookings(BuildContext context, String uid){
    Routemaster.of(context).push('/bookings/$uid');
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user/$uid');
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          IconButton(
            icon: CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(user!.profilePic),
            ),
            onPressed:(){},
          ),
          const SizedBox(height: 15),
          Text(
            user!.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () => navigateToHome(context),
            selectedColor: Pallete.orangeCustomColor,
            selected: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          ListTile(
            onTap: ()  => navigateToUserProfile(context, user.uid),
            selectedColor: Pallete.orangeCustomColor,
            selected: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.person_2),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () => navigateToCreateGroup(context),
            selectedColor: Pallete.orangeCustomColor,
            selected: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.add),
            title: const Text(
              "Create a New Group",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () => navigateToRequests(context, user.uid),
            selectedColor: Pallete.orangeCustomColor,
            selected: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.question_answer),
            title: const Text(
              "Requests",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () => navigateToBookings(context, user.uid),
            selectedColor: Pallete.orangeCustomColor,
            selected: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.calendar_month),
            title: const Text(
              "Bookings",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Pallete.redCustomColor
                            )),
                        IconButton(
                            onPressed: () async {logOut(ref);
                            Navigator.pop(context);},
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green
                            )),
                      ],
                    );
                  });
            },
            selectedColor: Pallete.orangeCustomColor,
            selected: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      ),
    ),
    );
  }
}