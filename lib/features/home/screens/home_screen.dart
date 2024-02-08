import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/features/nav/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:ensemble/core/common/error_text.dart';
import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/models/group_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void navigateToGroup(BuildContext context, GroupModel group) {
    Routemaster.of(context).push('/${group.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
        appBar:AppBar(
            title:const Text('Home'),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: (){
                const NavDrawer();
              },
            ),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search),),
              IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user!.profilePic),
                ),
                onPressed:(){},
              ),
            ]
        ),
        drawer: const NavDrawer(),
        body: ref.watch(userGroupsProvider).when(
          data: (groups) {
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int index){
                final group = groups[index];
                return ListTile(
                  leading: CircleAvatar (
                    backgroundImage : NetworkImage(group.groupPic),
                  ),
                  title: Text(group.name),
                  onTap: () {
                navigateToGroup(context, group);
                },
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        )
    );
  }
}