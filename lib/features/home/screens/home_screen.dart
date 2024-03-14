import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/features/nav/nav_drawer.dart';
import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:ensemble/core/common/error_text.dart';
import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/models/group_model.dart';

import '../delegates/search_group_delegate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void navigateToGroup(BuildContext context, GroupModel group) {
    Routemaster.of(context).push('/${group.id}');
  }

  void navigateToCreateGroup(BuildContext context) {
    Routemaster.of(context).push('/create-group');
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user/$uid');
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchGroupDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
            ),
            onPressed: () => navigateToUserProfile(context, user!.uid),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: ref.watch(userGroupsProvider).when(
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Get started! Either create a group, or search above for a group to join",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int index) {
                final group = groups[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(group.groupPic),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.name),
                      SizedBox(height: 4), // Adjust the spacing between name and description
                      Text(
                        group.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12, // Adjust the font size of the description
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    navigateToGroup(context, group);
                  },
                );
              },
            );
          }
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Container(
          width: MediaQuery.of(context).size.width, // Set width to full screen width
          child: FloatingActionButton.extended(
            onPressed: () => navigateToCreateGroup(context),
            backgroundColor: Pallete.orangeCustomColor,
            foregroundColor: Pallete.whiteColor,
            label: Text('Create a Group'),
            icon: Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}