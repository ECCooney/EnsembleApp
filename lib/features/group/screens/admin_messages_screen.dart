import 'package:ensemble/features/message/screens/message_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/group_model.dart';
import '../../../models/message_model.dart';
import '../../message/controller/message_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/group_controller.dart';

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
                  title: Text( message.subject),
                  subtitle: Text(message.text),
                  trailing: IconButton(
                    icon: Icon(Icons.open_in_new),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MessageDetailsScreen(id: message.id),
                        ),
                      );
                      changeToRead(ref, context, message);
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
        )
    ), error: (error, stackTrace) {
    print(error); // Print error for debugging purposes
    return ErrorText(error: error.toString());
    },
    loading: () => Loader()
    );
  }
}

