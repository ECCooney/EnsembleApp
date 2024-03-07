import 'package:ensemble/features/user/controller/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../nav/nav_drawer.dart';

class MessageResponsesScreen extends ConsumerWidget {

  final String uid;
  const MessageResponsesScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
        ),
        drawer: const NavDrawer(),
        body: ref.watch(getUserSentMessagesProvider(uid)).when(
          data: (messages) {
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.subject),
                  subtitle: Text('Status: ${message.response}'),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        )
    ) ;
  }
}
