import 'package:ensemble/features/message/screens/message_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/group_model.dart';
import '../../../models/message_model.dart';
import '../../message/controller/message_controller.dart';
import '../../nav/nav_drawer.dart';
import '../../group/controller/group_controller.dart';

class AdminMessagesScreen extends ConsumerWidget {

  final String id;
  const AdminMessagesScreen({
    required this.id,
    super.key});


  void deleteMessage(WidgetRef ref, BuildContext context, MessageModel message) {
    ref.read(messageControllerProvider.notifier).deleteMessage(message, context);
  }

  void changeToRead(WidgetRef ref, BuildContext context, MessageModel message) {
    ref.read(messageControllerProvider.notifier).changeToRead(message, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getGroupByIdProvider(id)).when(
      data: (group) => Scaffold(
        appBar: AppBar(
          title: const Text('Admin Messages'),
        ),
        drawer: const NavDrawer(),
        body: ref.watch(getGroupMessagesProvider(group.id)).when(
          data: (messages) {
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];

                return ListTile(
                  leading: message.isRead ? const Icon(Icons.mail_outline) : const Icon(Icons.mail),
                  title: Text(
                    message.subject,
                    style: TextStyle(
                      fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(message.text),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MessageDetailsScreen(id: message.id),
                        ),
                      );
                      if (!message.isRead) {
                        changeToRead(ref, context, message);
                      }
                    },
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        ),
      ),
      error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      },
      loading: () => const Loader(),
    );
  }
}