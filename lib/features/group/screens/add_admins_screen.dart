import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/group_controller.dart';


class AddAdminsScreen extends ConsumerStatefulWidget {
  final String id;
  const AddAdminsScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAdminsScreenState();
}

class _AddAdminsScreenState extends ConsumerState<AddAdminsScreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveAdmins() {
    ref.read(groupControllerProvider.notifier).addAdmins(
      widget.id,
      uids.toList(),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveAdmins,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: ref.watch(getGroupByIdProvider(widget.id)).when(
        data: (group) => ListView.builder(
          itemCount: group.members.length,
          itemBuilder: (BuildContext context, int index) {
            final member = group.members[index];

            return ref.watch(getUserDataProvider(member)).when(
              data: (user) {
                if (group.admins.contains(member) && ctr == 0) {
                  uids.add(member);
                }
                ctr++;
                return CheckboxListTile(
                  value: uids.contains(user.uid),
                  onChanged: (val) {
                    if (val!) {
                      addUid(user.uid);
                    } else {
                      removeUid(user.uid);
                    }
                  },
                  title: Text(user.name),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
          },
        ),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}