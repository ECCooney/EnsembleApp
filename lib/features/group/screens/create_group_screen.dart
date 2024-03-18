import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/theme/borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/loader.dart';

import '../../../theme/pallete.dart';
import '../../nav/nav_drawer.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final groupNameController = TextEditingController();
  final groupInviteCodeController = TextEditingController();
  final groupDescriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
    groupInviteCodeController.dispose();
    groupDescriptionController.dispose();
  }

  void createGroup() {
    ref.read(groupControllerProvider.notifier).createGroup(
      groupNameController.text.trim(),
      groupInviteCodeController.text.trim(),
      groupDescriptionController.text.trim(),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(groupControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create a Group'),
      ),
      drawer: const NavDrawer(),
      body: isLoading
          ? const Loader()
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Group Name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                hintText: 'My Group Name',
                filled: true,
                fillColor: Colors.white,
                border: Borders.outlinedBorder,
                focusedBorder: Borders.focusedBorder,
                enabledBorder: Borders.enabledBorder,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const SizedBox(height: 10),
            const Text(
              'Group Invite Code',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: groupInviteCodeController,
              decoration: InputDecoration(
                hintText: 'Unique Invite Code',
                filled: true,
                fillColor: Colors.white,
                border: Borders.outlinedBorder,
                focusedBorder: Borders.focusedBorder,
                enabledBorder: Borders.enabledBorder,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const SizedBox(height: 10),
            const Text(
              'Group Description',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: TextField(
                controller: groupDescriptionController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'A Short Description',
                  filled: true,
                  fillColor: Colors.white,
                  border: Borders.outlinedBorder,
                  focusedBorder: Borders.focusedBorder,
                  enabledBorder: Borders.enabledBorder,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLength: 150,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: createGroup,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Pallete.orangeCustomColor, // Change the button color to orange
              ),
              child: const Text(
                'Create Group',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}