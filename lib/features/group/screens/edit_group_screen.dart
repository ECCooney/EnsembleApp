import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ensemble/core/utils.dart';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../models/group_model.dart';
import '../../../theme/borders.dart';
import '../../../theme/pallete.dart';
import '../../nav/nav_drawer.dart';

class EditGroupScreen extends ConsumerStatefulWidget {
  final String id;

  const EditGroupScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends ConsumerState<EditGroupScreen> {
  File? groupBannerFile;
  File? groupPicFile;

  final groupDescriptionController = TextEditingController();
  final groupCodeController = TextEditingController();

  void chooseBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        groupBannerFile = File(res.files.first.path!);
      });
    }
  }

  void chooseGroupImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        groupPicFile = File(res.files.first.path!);
      });
    }
  }

  void saveEdit(GroupModel group) {
    ref.read(groupControllerProvider.notifier).editGroup(
      groupPicFile: groupPicFile,
      groupBannerFile: groupBannerFile,
      description: groupDescriptionController.text.trim(),
      inviteCode: groupCodeController.text.trim(),
      context: context,
      group: group,
    );
  }

  void deleteGroup(GroupModel group) {
    ref.read(groupControllerProvider.notifier).deleteGroup(group, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(groupControllerProvider);

    return ref.watch(getGroupByIdProvider(widget.id)).when(
      data: (group) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Group'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () => saveEdit(group),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        drawer: const NavDrawer(),
        body: isLoading
            ? const Loader()
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: chooseBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          dashPattern: const [10, 5],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: groupBannerFile != null
                                ? Image.file(groupBannerFile!)
                                : group.groupBanner.isEmpty ||
                                group.groupBanner ==
                                    Constants.backgroundDefault
                                ? const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 50,
                              ),
                            )
                                : Image.network(group.groupBanner),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: chooseGroupImage,
                          child: groupPicFile != null
                              ? CircleAvatar(
                            backgroundImage:
                            FileImage(groupPicFile!),
                            radius: 40,
                          )
                              : CircleAvatar(
                            backgroundImage:
                            NetworkImage(group.groupPic),
                            radius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Update the Group Invite Code',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: groupCodeController,
                  decoration: InputDecoration(
                    hintText: 'Current code: ${group.inviteCode}',
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
                  'Update the Group Description',
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
                      hintText: 'Currently description: ${group.description}',
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
                  onPressed: () => saveEdit(group),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Pallete.orangeCustomColor, // Change the button color to orange
                  ),
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
    );
  }
}