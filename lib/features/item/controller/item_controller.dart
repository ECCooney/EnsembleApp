import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/core/providers/storage_repository_providers.dart';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/features/item/repository/item_repository.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/core/utils.dart';
import 'package:ensemble/models/item_model.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';

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


  // Stream<List<ItemModel>> getUserItems() {
  //   final uid = _ref.read(userProvider)!.uid;
  //   return _itemRepository.getUserItems(uid);
  // }

  Stream<ItemModel> getItemById(String id) {
    return _itemRepository.getItemById(id);
  }
}