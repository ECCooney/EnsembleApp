import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/item_card.dart';
import '../../../core/common/loader.dart';
import '../../../models/group_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../group/controller/group_controller.dart';
import '../../../theme/pallete.dart';

class GroupScreen extends ConsumerWidget {
  final String id;

  const GroupScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  void navigateToAdminTools(BuildContext context) {
    Routemaster.of(context).push('/admin-tools/$id');
  }

  void navigateToJoinGroup(BuildContext context) {
    Routemaster.of(context).push('/join-group/$id');
  }

  void navigateToCreateItem(BuildContext context) {
    Routemaster.of(context).push('/create-item/$id');
  }

  void leaveGroup(WidgetRef ref, GroupModel group, BuildContext context) {
    ref.read(groupControllerProvider.notifier).leaveGroup(group, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getGroupByIdProvider(id)).when(
        data: (group) {
          final bool isMember = group.members.contains(user.uid);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(group.groupBanner, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(group.groupPic),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                if (group.admins.contains(user.uid)) {
                                  navigateToAdminTools(context);
                                } else if (isMember) {
                                  leaveGroup(ref, group, context);
                                } else {
                                  navigateToJoinGroup(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text(
                                group.admins.contains(user.uid)
                                    ? 'Admin Tools'
                                    : isMember
                                    ? 'Leave'
                                    : 'Join',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: isMember
                ? ref.watch(getGroupItemsProvider(id)).when(
              data: (items) {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    return ItemCard(item: item);
                  },
                );
              },
              error: (error, stackTrace) {
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader(),
            )
                : const SizedBox(), // Non-members don't see the ListView
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
      floatingActionButton: ref.watch(getGroupByIdProvider(id)).maybeWhen(
        data: (group) {
          final bool isMember = group.members.contains(user.uid);
          if (isMember) {
            return FloatingActionButton(
              onPressed: () {
                navigateToCreateItem(context);
              },
              backgroundColor: Pallete.sageCustomColor,
              child: const Icon(Icons.add),
            );
          } else {
            return null; // Non-members don't see the FloatingActionButton
          }
        },
        orElse: () => null,
      ),
    );
  }
}