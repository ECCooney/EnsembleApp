import 'package:ensemble/core/providers/storage_repository_providers.dart';
import 'package:ensemble/features/item/repository/item_repository.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/core/utils.dart';
import 'package:ensemble/models/item_model.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';

import '../../../models/booking_model.dart';

final itemsProvider = StreamProvider.family((ref, List<GroupModel> groups) {
  final itemController = ref.watch(itemControllerProvider.notifier);
  return itemController.getItems(groups);
});

final itemControllerProvider = StateNotifierProvider<ItemController, bool>((ref) {
  final itemRepository = ref.watch(itemRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ItemController(itemRepository: itemRepository, ref: ref, storageRepository: storageRepository);
});

final getItemByIdProvider = StreamProvider.family((ref, String id) {
  final itemController = ref.watch(itemControllerProvider.notifier);
  return itemController.getItemById(id);
});

final getItemBookingsProvider = StreamProvider.family((ref, String id) {
  final itemController = ref.watch(itemControllerProvider.notifier);
  return itemController.getItemBookings(id);
});

final getBookedDatesProvider =
FutureProvider.family<List<DateTime>, String>((ref, itemId) async {
  final itemController = ref.watch(itemControllerProvider.notifier);
  return await itemController.getBookedDates(itemId);
});



class ItemController extends StateNotifier<bool> {
  final ItemRepository _itemRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ItemController({
    required ItemRepository itemRepository,
    required Ref ref,
    required StorageRepository storageRepository
  }): _itemRepository = itemRepository,
        _ref = ref,
  _storageRepository = storageRepository,
        super(false);

  void createItem({
    required BuildContext context,
    required String name,
    required String description,
    required String category,
    required GroupModel group,

  }) async {
    state = true;
    String itemId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final ItemModel item = ItemModel(
      id: itemId,
      name: name,
      description: description,
      category: category,
      groupId: group.id,
      owner: user.uid,
      itemPic: Constants.groupAvatarDefault,
    );

    final res = await _itemRepository.addItem(item);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Added successfully!');
      Routemaster.of(context).pop();
    });
  }

  void editItem({
    required File? itemPicFile,
    required String? description,
    required String? name,
    required BuildContext context,
    required ItemModel item,
  }) async {
    if (itemPicFile != null) {
      // groups/groupPic/groupId
      final res = await _storageRepository.storeFile(
        path: 'items/itemPic',
        id: item.id,
        file: itemPicFile,
      );
      res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => item = item.copyWith(itemPic: r),
      );
    }
    if (description != null && description.isNotEmpty) {
      item = item.copyWith(description: description);
    }
    if (name != null && name.isNotEmpty) { // Check if name is not null and not empty
      item = item.copyWith(name: name);
    }
    final res = await _itemRepository.editItem(item);

    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => Routemaster.of(context).pop(),
    );
  }


  Stream<List<ItemModel>> getItems(List<GroupModel> groups) {
    if (groups.isNotEmpty) {
      return _itemRepository.getItems(groups);
    }
    return Stream.value([]);
  }

  void deleteItem(ItemModel item, BuildContext context) async {
    final res = await _itemRepository.deleteItem(item);
    res.fold((l) => null, (r) => showSnackBar(context, 'Item Deleted successfully!'));
  }


  Stream<ItemModel> getItemById(String id) {
    return _itemRepository.getItemById(id);
  }

  Stream<List<BookingModel>> getItemBookings(String id) {
    return _itemRepository.getItemBookings(id);
  }

  Future<List<DateTime>> getBookedDates(String itemId) async {
    final bookings = await _itemRepository.getItemBookings(itemId).first;

    List<DateTime> bookedDates = [];

    if (bookings != null) {
      for (var booking in bookings) {
        final bookingStart = booking.bookingStart;
        final bookingEnd = booking.bookingEnd;

        final bookingRange = List<DateTime>.generate(
          (bookingEnd.difference(bookingStart).inDays + 1),
              (index) => bookingStart.add(Duration(days: index)),
        );
        bookedDates.addAll(bookingRange);
      }
    }
    return bookedDates;
  }


}