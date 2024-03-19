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
import '../../nav/nav_drawer.dart';


class GroupScreen extends ConsumerStatefulWidget {

  final String id;
  const GroupScreen({
    Key? key,
    required this.id,
  }) : super(key: key);


  @override
  ConsumerState createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {

  final List<String> categories = ['DIY', 'Household', 'Clothing', 'Family', 'Other'];
  List <String> selectedCategories = [];


  void navigateToAdminTools(BuildContext context) {
    Routemaster.of(context).push('/admin-tools/${widget.id}');
  }

  void navigateToJoinGroup(BuildContext context) {
    Routemaster.of(context).push('/join-group/${widget.id}');
  }

  void navigateToCreateItem(BuildContext context) {
    Routemaster.of(context).push('/create-item/${widget.id}');
  }

  void navigateToMessageAdmins(BuildContext context) {
    Routemaster.of(context).push('/message-admins/${widget.id}');
  }


  void leaveGroup(WidgetRef ref, GroupModel group, BuildContext context) {
    ref.read(groupControllerProvider.notifier).leaveGroup(group, context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      drawer: const NavDrawer(),
      body: ref.watch(getGroupByIdProvider(widget.id)).when(
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
                                fontSize: 24,
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
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: BorderSide(color: Pallete.orangeCustomColor),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text(
                                group.admins.contains(user.uid)
                                    ? 'Admin Tools'
                                    : isMember
                                    ? 'Leave'
                                    : 'Join',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          group.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: categories.map((category) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                selectedColor: Pallete.orangeCustomColorTransp,
                                selected: selectedCategories.contains(category),
                                label: Text(category),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedCategories.add(category);
                                    } else {
                                      selectedCategories.remove(category);
                                    }
                                  });
                                },
                              ),
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: isMember
                ? ref.watch(getGroupItemsProvider(widget.id)).when(
              data: (items) {
                final filteredItems = items.where((item) {
                  return selectedCategories.isEmpty|| selectedCategories.contains(item.category);
                }).toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(4.0),
                  itemCount: filteredItems.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 3.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    var item = filteredItems[index];
                    return GestureDetector(
                      onTap: () {},
                      child: ItemCard(item: item),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader(),
            )
                : const SizedBox(), // Non-members don't see the GridView
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ref.watch(getGroupByIdProvider(widget.id)).maybeWhen(
            data: (group) {
              final bool isMember = group.members.contains(user.uid);
              if (isMember) {
                return FloatingActionButton(
                  onPressed: () {
                    navigateToCreateItem(context);
                  },
                  backgroundColor: Pallete.orangeCustomColor,
                  foregroundColor: Pallete.whiteColor,
                  heroTag: null,
                  child: const Icon(Icons.add),
                );
              } else {
                return const SizedBox(); // Non-members don't see the FloatingActionButton
              }
            },
            orElse: () => const SizedBox(),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              navigateToMessageAdmins(context);
            },
            backgroundColor: Pallete.orangeCustomColor,
            foregroundColor: Pallete.whiteColor,// Example color
            child: const Icon(Icons.message),
            heroTag: null, // Example icon
          ),
        ],
      ),
    );
  }
}