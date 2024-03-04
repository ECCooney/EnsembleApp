import 'dart:io';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/features/item/controller/item_controller.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:ensemble/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/loader.dart';

import '../../../core/common/error_text.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/message_controller.dart';

class MessageAdminsScreen extends ConsumerStatefulWidget {
  final String id;
  const MessageAdminsScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MessageAdminsScreenState();
}

class _MessageAdminsScreenState extends ConsumerState<MessageAdminsScreen> {

  final messageSubjectController = TextEditingController();
  final messageTextController = TextEditingController();

  //https://javeedishaq.medium.com/understanding-the-dispose-method-in-flutter-e96d9a19442a#:~:text=In%20Flutter%2C%20the%20dispose%20method,can%20be%20safely%20cleaned%20up.
  @override
  void dispose() {
    super.dispose();
    messageSubjectController.dispose();
    messageTextController.dispose();
  }


  void sendMessage(GroupModel group) {
    if (messageSubjectController.text.isNotEmpty) {
      ref.read(messageControllerProvider.notifier).sendMessage(
        context: context,
        subject: messageSubjectController.text.trim(),
        text: messageTextController.text.trim(),
        group: group,
      );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(itemControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Group Admins'),
      ),
      drawer: const NavDrawer(),
      body: isLoading
          ? const Loader()
          : ref.watch(getGroupByIdProvider(widget.id)).when(
        data: (group) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Subject'),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: messageSubjectController,
                  decoration: const InputDecoration(
                    hintText: 'Subject',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Message Content'),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 140, // <-- TextField height
                  child: TextField(
                    controller: messageTextController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Message Body',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 150,
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () => sendMessage(group),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          );
        }, loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
      ),
    );
  }
}