import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/user_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profilePicFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }


  void changeProfilePic() async {
    final res = await pickImage();

    if (res != null) {
        setState(() {
          profilePicFile = File(res.files.first.path!);
        });
      }
    }

  void save() {
    ref.read(userControllerProvider.notifier).editUser(
      profilePicFile: profilePicFile,
      context: context,
      name: nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userControllerProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) => Scaffold(
        backgroundColor: Pallete.whiteColor,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: save,
              child: const Text('Save'),
            ),
          ],
        ),
        body: isLoading
            ? const Loader()
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: changeProfilePic,
                          child: profilePicFile != null
                              ? CircleAvatar(
                            backgroundImage: FileImage(profilePicFile!),
                            radius: 32,
                          )
                              : CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),
              ],
            ),
          ),
        ),       loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
    );
  }
}