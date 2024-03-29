import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:io';

import '../../../core/providers/storage_repository_providers.dart';
import '../../../core/utils.dart';
import '../../../models/booking_model.dart';
import '../../../models/group_model.dart';
import '../../../models/item_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/user_repository.dart';

final userControllerProvider = StateNotifierProvider<UserController, bool>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserController(
    userRepository: userRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getUserItemsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userControllerProvider.notifier).getUserItems(uid);
});

final getGroupsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userControllerProvider.notifier).getUserGroups(uid);
});

final getUserBookingsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userControllerProvider.notifier).getUserBookings(uid);
});

final getUserSentMessagesProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userControllerProvider.notifier).getUserSentMessages(uid);
});

final getRequests = StreamProvider.family((ref, String uid) {
  return ref.read(userControllerProvider.notifier).getRequests(uid);
});

class UserController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserController({
    required UserRepository userRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })
      : _userRepository = userRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUser({
    required File? profilePicFile,
    required BuildContext context,
    required String name,
    required String email,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profilePicFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profilePicFile,
      );
      res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => user = user.copyWith(profilePic: r),
      );
    }

    // Check if name and email are not empty or null before copying
    if (name.isNotEmpty && email.isNotEmpty) {
      user = user.copyWith(name: name, email: email);
    } else if (name.isEmpty) {
      showSnackBar(context, 'Name cannot be empty');
      return;
    } else if (email.isEmpty) {
      showSnackBar(context, 'Email cannot be empty');
      return;
    }

    final res = await _userRepository.editProfile(user);
    state = false;
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<ItemModel>> getUserItems(String uid) {
    return _userRepository.getUserItems(uid);
  }

  Stream<List<BookingModel>> getUserBookings(String uid) {
    return _userRepository.getUserBookings(uid);
  }

  Stream<List<MessageModel>> getUserSentMessages(String uid) {
    return _userRepository.getUserSentMessages(uid);
  }

  Stream<List<BookingModel>> getRequests(String uid) {
    return _userRepository.getRequests(uid);
  }

  Stream<List<GroupModel>> getUserGroups(String uid) {
    return _userRepository.getGroups(uid);
  }
}
