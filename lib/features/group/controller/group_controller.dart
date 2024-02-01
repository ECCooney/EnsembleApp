import 'package:ensemble/features/group/repository/group_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../models/group_model.dart';
import '../../auth/controller/auth_controller.dart';

final userGroupsProvider = StreamProvider((ref) {
  final groupController = ref.watch(groupControllerProvider.notifier);
  return groupController.getUserGroups();
});

final groupControllerProvider = StateNotifierProvider<GroupController, bool>((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository, ref: ref);
});

class GroupController extends StateNotifier<bool> {
  final GroupRepository _groupRepository;
  final Ref _ref;
  GroupController({
    required GroupRepository groupRepository,
    required Ref ref,
  }): _groupRepository = groupRepository,
        _ref = ref,
        super(false);

  void createGroup(String name, String description, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    String groupId = const Uuid().v1();
    GroupModel group = GroupModel(
      id: groupId,
      name: name,
      description: description,
      groupPic: Constants.avatarDefault,
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
}