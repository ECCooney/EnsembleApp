import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/group_model.dart';
import '../../nav/nav_drawer.dart';
import '../controller/group_controller.dart';


class AdminToolsScreen extends ConsumerStatefulWidget {
  final String id;
  const AdminToolsScreen({
    required this.id,
    super.key});


  @override
  ConsumerState createState() => _AdminToolsScreenState();
}

class _AdminToolsScreenState extends ConsumerState<AdminToolsScreen> {

  void deleteGroup(GroupModel group) {
    ref.read(groupControllerProvider.notifier).deleteGroup(group, context);
  }

  void navigateToEditGroup(BuildContext context) {
    Routemaster.of(context).push('/edit-group/${widget.id}');
  }

  void navigateToAddAdmins(BuildContext context) {
    Routemaster.of(context).push('/add-admins/${widget.id}');
  }


  @override
  Widget build(BuildContext context) {final isLoading = ref.watch(groupControllerProvider);

  return ref.watch(getGroupByIdProvider(widget.id)).when(
      data: (group) => Scaffold(
      appBar: AppBar(
        title: const Text('Admin Tools'),
      ),
        drawer: const NavDrawer(),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add New Admin'),
              onTap: () => navigateToAddAdmins(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Group Details'),
              onTap: () => navigateToEditGroup(context),
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('View Messages'),
              onTap: () {
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  leading: const Icon(Icons.message_outlined),
                  title: const Text('Delete Group'),
                  onTap: () => deleteGroup(group),
                ),
              ),
            ),
          ],
      )
      ),
    loading: () => const Loader(),
    error: (error, stackTrace) => ErrorText(
      error: error.toString(),
    ),
  );
  }
}