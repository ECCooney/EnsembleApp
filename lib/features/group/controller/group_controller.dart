import 'dart:io';

import 'package:ensemble/features/group/repository/group_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/core/utils.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';

import '../../../core/failure.dart';
import '../../../core/providers/storage_repository_providers.dart';
import '../../../models/item_model.dart';

final groupProvider = StateProvider<GroupModel?>((ref) => null);

final userGroupsProvider = StreamProvider((ref) {
  final groupController = ref.watch(groupControllerProvider.notifier);
  return groupController.getUserGroups();
});

final groupControllerProvider = StateNotifierProvider<GroupController, bool>((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return GroupController(
      groupRepository: groupRepository,
      storageRepository: storageRepository,
      ref: ref);
});

final searchGroupProvider = StreamProvider.family((ref, String query) {
  return ref.watch(groupControllerProvider.notifier).searchGroup(query);
});

final getGroupByIdProvider = StreamProvider.family((ref, String id) {
  final groupController = ref.watch(groupControllerProvider.notifier);
  return groupController.getGroupById(id);
});

final getGroupItemsProvider = StreamProvider.family((ref, String id) {
  final groupController = ref.watch(groupControllerProvider.notifier);
  return groupController.getGroupItems(id);
});

class GroupController extends StateNotifier<bool> {
  final GroupRepository _groupRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  GroupController({
    required GroupRepository groupRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  }) : _groupRepository = groupRepository,
       _ref = ref,
       _storageRepository = storageRepository,
        super(false);

  void createGroup(String name, String inviteCode, String description, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    String groupId = const Uuid().v1();
    GroupModel group = GroupModel(
      id: groupId,
      inviteCode: inviteCode,
      name: name,
      description: description,
      groupPic: Constants.groupAvatarDefault,
      groupBanner: Constants.backgroundDefault,
      members: [uid],
      admins: [uid],
    );

    final res = await _groupRepository.createGroup(group);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Group Created Successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<GroupModel>> getUserGroups() {
    final uid = _ref.read(userProvider)!.uid;
    return _groupRepository.getUserGroups(uid);
  }

  void editGroup({
    required File? groupPicFile,
    required File? groupBannerFile,
    required String? description,
    required String? inviteCode,
    required BuildContext context,
    required GroupModel group,
  }) async {
    if (groupPicFile != null) {
      // groups/groupPic/groupId
      final res = await _storageRepository.storeFile(
        path: 'groups/groupPic',
        id: group.id,
        file: groupPicFile,
      );
      res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => group = group.copyWith(groupPic: r),
      );
    }
    if (groupBannerFile != null) {
      // groups/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'groups/banner',
        id: group.id,
        file: groupBannerFile,
      );
      res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => group = group.copyWith(groupBanner: r),
      );
    }
    if (description != null && description.isNotEmpty) {
      group = group.copyWith(description: description);
    }
    if (inviteCode != null && inviteCode.isNotEmpty) { // Check if name is not null and not empty
      group = group.copyWith(inviteCode: inviteCode);
    }


    final res = await _groupRepository.editGroup(group);

    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => Routemaster.of(context).pop(),
    );
  }

  void deleteGroup(GroupModel group, BuildContext context) async {
    state = true;
    final res = await _groupRepository.deleteGroup(group);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Group Deleted Permanently');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<GroupModel>> searchGroup(String query) {
    return _groupRepository.searchGroup(query);
  }


  void leaveGroup(GroupModel group, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    await _groupRepository.leaveGroup(group.id, user.uid);

  }

  void joinGroup(GroupModel group, String inviteCode, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (inviteCode == group.inviteCode) {
      res = await _groupRepository.joinGroup(group.id, group.inviteCode, user.uid);
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Joined Group!');
        Routemaster.of(context).pop();
      });
    }

  }

  void addAdmins(String groupId, List<String> uids, BuildContext context) async {
    final res = await _groupRepository.addAdmins(groupId, uids);
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<GroupModel> getGroupById(String id) {
    return _groupRepository.getGroupById(id);
  }

  Stream<List<ItemModel>> getGroupItems(String id) {
    return _groupRepository.getGroupItems(id);
  }
}