import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/theme/borders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../../../models/message_model.dart';
import '../../../theme/pallete.dart';
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
  List<String> responses = [
    'Code Request Approved',
    'Code Request Denied',
    'Report Received',
  ];

  String selectedResponse = '';

  @override
  void dispose() {
    super.dispose();
    responseController.dispose();
  }

  void deleteMessage(MessageModel message) {
    ref.read(messageControllerProvider.notifier).deleteMessage(
        message, context);
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
      data: (message) =>
          Scaffold(
            appBar: AppBar(
              title: const Text('Message Details'),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    deleteMessage(message);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Pallete.blackColor, // Customize the icon color as needed
                  ),
                ),
              ],
            ),
            drawer: const NavDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Fetch user details using the booking.requester field
                  ref.watch(getUserDataProvider(message.senderId)).when(
                    data: (userData) {
                      // Display user details
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sender:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                userData.name,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    // Show loading indicator while fetching user details
                    error: (error, stackTrace) =>
                        ErrorText(
                          error: error.toString(),
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Subject:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message.subject,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0), // Add padding as needed
                      child: Text(message.text,
                      style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 15),
                  ref.watch(getGroupByIdProvider(message.groupId)).when(
                    data: (group) {
                      if (message.subject == 'Code Request') {
                        return Center(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  addResponse(message,
                                      "Thanks for requesting to join ${group
                                          .name}. Use code '${group
                                          .inviteCode}' to join");
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Pallete.orangeCustomColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Approve Request',
                                  style: TextStyle(
                                    color: Pallete.whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  addResponse(message,
                                      "Your request to join ${group
                                          .name} has been denied. This is a closed group");
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Pallete.orangeCustomColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Deny Request',
                                  style: TextStyle(
                                    color: Pallete.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (message.subject == 'Report an Issue') {
                        return ElevatedButton(
                          onPressed: () {
                            addResponse(message,
                                'Thanks for submitting your report. We will look into this immediately');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Pallete.orangeCustomColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Confirm Received',
                            style: TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        );
                      }
                      // Display user details
                      return const Loader();
                    },
                    loading: () => const Loader(),
                    // Show loading indicator while fetching user details
                    error: (error, stackTrace) =>
                        ErrorText(
                          error: error.toString(),
                        ),
                  ),
                ],
              ),
            ),
          ),
      loading: () => const Loader(),
      error: (error, stackTrace) =>
          ErrorText(
            error: error.toString(),
          ),
    );
  }
}