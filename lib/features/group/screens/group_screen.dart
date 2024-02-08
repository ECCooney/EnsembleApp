import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/error_text.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class GroupScreen extends ConsumerWidget {

  //id needed for dyanmic routing
  final String id;
  const GroupScreen({
    super.key,
    required this.id,
});

  void navigateToAdminTools(BuildContext context) {
    Routemaster.of(context).push('/admin-tools/$id');
  }

  void navigateToCreateItem(BuildContext context) {
    Routemaster.of(context).push('/create-item/$id');
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getGroupByIdProvider(id)).when(
          data: (group) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.network(group.groupBanner, fit: BoxFit.cover,)
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(group.groupPic),
                          radius: 30),
                      ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(group.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              )
                              ),
                              group.admins.contains(user.uid)?
                              OutlinedButton(
                                onPressed: () {
                                  navigateToAdminTools(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                ),
                                child: const Text('Admin Tools'),
                              )
                              :
                              OutlinedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                ),
                                child: Text(group.members.contains(user.uid)? 'Joined' : 'Join'),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              group.description
                            )
                          ),
                    ])
                    )

                  )
                ];
              },
              body: const Text('Display items here')
              ),

         error:(error, stackTrace) => ErrorText(error: error.toString()),
         loading: () => const Loader()),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
      navigateToCreateItem(context);
    },
    child: Icon(Icons.add),
    backgroundColor: Pallete.sageCustomColor,
    ),
    );
  }
}