import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/custom_text_field.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
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
  late TextEditingController emailController; // Add email controller

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    emailController = TextEditingController(text: ref.read(userProvider)!.email); // Initialize email controller
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose(); // Dispose of email controller
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
      email: emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userControllerProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) => Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: Pallete.whiteColor,
        appBar: AppBar(
          backgroundColor: Pallete.whiteColor,
          title: const Text('Edit Profile'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: save,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: changeProfilePic,
                              child: profilePicFile != null
                                  ? CircleAvatar(
                                backgroundImage: FileImage(profilePicFile!),
                                radius: 72,
                              )
                                  : CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 90,
                              ),
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Pallete.orangeCustomColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Add spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name', // Header for the name field
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CustomTextField(
                        controller: nameController,
                        hintText: user.name,
                        validator: (value) {  },
                        icon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 20), // Add spacing
                      const Text(
                        'Email Address', // Header for the email address field
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: user.email,
                        validator: (value) {  },
                        icon: const Icon(Icons.mail),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        // Center the button
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the buttons evenly across the screen width
                          children: [
                            Expanded( // Wrap the first button with Expanded widget
                              child: ElevatedButton(
                                onPressed: save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // Set button background color to transparent
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Apply rounded corners
                                    side: const BorderSide(color: Pallete.orangeCustomColor), // Add orange outline
                                  ),
                                ),
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Pallete.orangeCustomColor, fontSize: 16), // Set button text style with orange color
                                ),
                              ),
                            ),
                            const SizedBox(width: 12), // Add spacing between buttons
                            Expanded( // Wrap the second button with Expanded widget
                              child: ElevatedButton(
                                onPressed: () {
                                  nameController.clear();
                                  emailController.clear();
                                  // Implement cancel functionality here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.orangeCustomColor, // Set button background color to orange
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Apply rounded corners
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white, fontSize: 16), // Set button text style with white color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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