import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/storage_repository_providers.dart';
import '../../../core/utils.dart';
import '../../../models/booking_model.dart';
import '../../../models/item_message_model.dart';
import '../../../models/item_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/message_repository.dart';

final itemMessagesProvider = StreamProvider.family((ref, List<ItemModel> items) {
  final messageController = ref.watch(messageControllerProvider.notifier);
  return messageController.getItemMessages(items);
});

final messageControllerProvider = StateNotifierProvider<MessageController, bool>((ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return MessageController(messageRepository: messageRepository, ref: ref, storageRepository: storageRepository);
});

final getItemMessageByIdProvider = StreamProvider.family((ref, String id) {
  final messageController = ref.watch(messageControllerProvider.notifier);
  return messageController.getItemMessageById(id);
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

  void createItemMessage({
    required BuildContext context,
    required String subject,
    required String text,
    required BookingModel booking

  }) async {
    state = true;
    String messageId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final ItemMessageModel itemMessage = ItemMessageModel(
      id: messageId,
      itemId: booking.itemId,
      senderId: user.uid,
      senderName: user.name,
      subject: subject,
      text: text,
      bookingID: booking.id

    );

    final res = await _messageRepository.addItemMessage(itemMessage);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Added successfully!');
      Routemaster.of(context).pop();
    });
  }


  Stream<List<ItemMessageModel>> getItemMessages(List<ItemModel> items) {
    if (items.isNotEmpty) {
      return _messageRepository.getItemMessages(items);
    }
    return Stream.value([]);
  }

  void deleteItemMessage(ItemMessageModel itemMessage, BuildContext context) async {
    final res = await _messageRepository.deleteItemMessage(itemMessage);
    res.fold((l) => null, (r) => showSnackBar(context, 'Message Deleted successfully!'));
  }

  Stream<ItemMessageModel> getItemMessageById(String id) {
    return _messageRepository.getItemMessageById(id);
  }
}