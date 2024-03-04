import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../../../models/message_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/message_controller.dart';

class MessageDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  const MessageDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _MessageDetailsScreenState createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends ConsumerState<MessageDetailsScreen> {
  final responseController = TextEditingController();
  List<String> reponses = [
    'Code Request Approved',
    'Code Request Approved',
    'Report Received',
    'General Query Response'
  ];

  String selectedResponse = '';

  @override
  void dispose() {
    super.dispose();
    responseController.dispose();
  }

  void deleteMessage(MessageModel message) {
    ref.read(messageControllerProvider.notifier).deleteMessage(message, context);
  }

  void addResponse(MessageModel message, String response) {
    ref.read(messageControllerProvider.notifier).addResponse(
      response: response,
      context: context,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messageControllerProvider);
    return ref.watch(getMessageByIdProvider(widget.id)).when(
      data: (message) => Scaffold(
        appBar: AppBar(
          title: const Text('Message Details'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () => deleteMessage(message),
              child: const Text('Delete Message'),
            ),
          ],
        ),
        drawer: const NavDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Requester Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'From',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              // Fetch user details using the booking.requester field
              ref.watch(getUserDataProvider(message.senderId)).when(
                data: (userData) {
                  // Display user details
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sender: ${userData.name}'),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                // Show loading indicator while fetching user details
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  ('Subject: ${message.subject}'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              // Display booking details
              Text(message.text),
              ref.watch(getGroupByIdProvider(message.groupId)).when(
                data: (group) {
                  if (message.subject == 'Code Request') {
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            addResponse(message, "Thanks for requesting to join ${group.name}. Use ${group.inviteCode}");
                          },
                          child: const Text('Approve Request'),
                        ),
                        const SizedBox(width: 10), // Add some space between the buttons
                        ElevatedButton(
                          onPressed: () {
                            addResponse(message, "Your request to join ${group.name} has been denied. This is a closed group");
                          },
                          child: const Text('Deny Request'),
                        ),
                      ],
                    );
                  } else if (message.subject == 'Report an Issue') {
                    return ElevatedButton(
                      onPressed: () {
                        addResponse(message, 'Thanks for submitting your report. We will look into this immediately');
                      },
                      child: const Text('Confirm Received'),
                    );
                  }
                  // Display user details
                  return const Loader();
                },
                loading: () => const Loader(),
                // Show loading indicator while fetching user details
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
              ),
            ],
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