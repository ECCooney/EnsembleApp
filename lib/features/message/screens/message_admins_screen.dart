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
import '../../../theme/borders.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../../message/controller/message_controller.dart';
import '../../nav/nav_drawer.dart';

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

  List<String> subjects = ['Code Request', 'Report an Issue'];
  String? subject;

  final subjectController = TextEditingController();
  final textController = TextEditingController();

  //https://javeedishaq.medium.com/understanding-the-dispose-method-in-flutter-e96d9a19442a#:~:text=In%20Flutter%2C%20the%20dispose%20method,can%20be%20safely%20cleaned%20up.
  @override
  void dispose() {
    super.dispose();
    subjectController.dispose();
    textController.dispose();
  }

  void sendMessage(GroupModel group) {
    if (textController.text.isNotEmpty) {
      ref.read(messageControllerProvider.notifier).sendMessage(
        context: context,
        subject: subject ?? subjects[0],
        text: textController.text.trim(),
        group: group,
      );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(messageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Admins'),
        backgroundColor: Pallete.orangeCustomColor, // Change app bar color to orange
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
                Container(
                  height: 75,
                  width: double.infinity,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: Borders.outlinedBorder,
                      focusedBorder: Borders.focusedBorder,
                      enabledBorder: Borders.enabledBorder,
                    ),
                    child: DropdownButton(
                      value: subject ?? subjects[0],
                      items: subjects
                          .map(
                            (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e), // Changed 'category' to e
                        ),
                      )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          subject = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Message Content'),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 160, // <-- TextField height
                  child: TextField(
                    controller: textController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: Borders.outlinedBorder,
                      focusedBorder: Borders.focusedBorder,
                      enabledBorder: Borders.enabledBorder,
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
                    backgroundColor: Pallete.orangeCustomColor, // Change button color to orange
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
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