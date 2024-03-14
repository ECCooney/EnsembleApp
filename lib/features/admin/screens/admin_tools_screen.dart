import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/group_model.dart';
import '../../nav/nav_drawer.dart';
import '../../group/controller/group_controller.dart';


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

  void navigateToAdminMessages(BuildContext context) {
    Routemaster.of(context).push('/view-messages/${widget.id}');
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
              leading: const Icon(Icons.add_moderator,
              color: Pallete.orangeCustomColor),
              title: const Text('Add New Admin'),
              onTap: () => navigateToAddAdmins(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit,
                  color: Pallete.orangeCustomColor),
              title: const Text('Edit Group Details'),
              onTap: () => navigateToEditGroup(context),
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined,
                  color: Pallete.orangeCustomColor),
              title: const Text('View Messages'),
              onTap: () => navigateToAdminMessages(context)
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => deleteGroup(group), // Use deleteGroup function for onPressed
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Pallete.orangeCustomColor, // Change the button color to orange
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10), // Add spacing between icon and text
                        Text(
                          'Delete Group',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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