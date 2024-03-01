import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/storage_repository_providers.dart';
import '../../../core/utils.dart';
import '../../../models/booking_model.dart';
import '../../../models/group_model.dart';
import '../../../models/item_model.dart';
import '../../../models/message_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/message_repository.dart';

final messagesProvider = StreamProvider.family((ref, List<GroupModel> groups) {
  final messageController = ref.watch(messageControllerProvider.notifier);
  return messageController.getMessages(groups);
});

final messageControllerProvider = StateNotifierProvider<MessageController, bool>((ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return MessageController(messageRepository: messageRepository, ref: ref, storageRepository: storageRepository);
});

final getMessageByIdProvider = StreamProvider.family((ref, String id) {
  final messageController = ref.watch(messageControllerProvider.notifier);
  return messageController.getMessageById(id);
});

class MessageController extends StateNotifier<bool> {
  final MessageRepository _messageRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  MessageController({
    required MessageRepository messageRepository,
    required Ref ref,
    required StorageRepository storageRepository
  }): _messageRepository = messageRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void sendMessage({
    required BuildContext context,
    required String subject,
    required String text,
    required GroupModel group

  }) async {
    state = true;
    String messageId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final MessageModel message = MessageModel(
      id: messageId,
      groupId: group.id,
      senderId: user.uid,
      senderName: user.name,
      subject: subject,
      text: text,
      isRead: false,
    );

    final res = await _messageRepository.addMessage(message);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Added successfully!');
      Routemaster.of(context).pop();
    });
  }


  Stream<List<MessageModel>> getMessages(List<GroupModel> groups) {
    if (groups.isNotEmpty) {
      return _messageRepository.getMessages(groups);
    }
    return Stream.value([]);
  }

  void deleteMessage(MessageModel message, BuildContext context) async {
    final res = await _messageRepository.deleteMessage(message);
    res.fold((l) => null, (r) => showSnackBar(context, 'Message Deleted successfully!'));
  }

  Stream<MessageModel> getMessageById(String id) {
    return _messageRepository.getMessageById(id);
  }
}