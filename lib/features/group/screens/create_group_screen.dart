import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/loader.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {

  final groupNameController = TextEditingController();

  final groupInviteCodeController = TextEditingController();
  final groupDescriptionController = TextEditingController();

  //https://javeedishaq.medium.com/understanding-the-dispose-method-in-flutter-e96d9a19442a#:~:text=In%20Flutter%2C%20the%20dispose%20method,can%20be%20safely%20cleaned%20up.
  @override
  void dispose(){
    super.dispose();
    groupNameController.dispose();
    groupInviteCodeController.dispose();
    groupDescriptionController.dispose();
  }

  void createGroup() {
    ref.read(groupControllerProvider.notifier).createGroup(
      //trim removes white space at end of anything typed in
      groupNameController.text.trim(),
      groupInviteCodeController.text.trim(),
      groupDescriptionController.text.trim(),
      context,
    );
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(groupControllerProvider);
    return Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: const Text ('Create a Group'),
        ),
        body: isLoading?
        const Loader() :
        Padding(
          padding: const EdgeInsets.all(10.0),
            child: Column(
                children: [
                  const Align(alignment: Alignment.topLeft,
                    child: Text('Group Name'),),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: groupNameController,
                    decoration: const InputDecoration(
                      hintText: 'My Group Name',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const Align(alignment: Alignment.topLeft,
                    child: Text('Group Invite Code'),),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: groupInviteCodeController,
                    decoration: const InputDecoration(
                      hintText: 'Unique Invite Code',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const Align(alignment: Alignment.topLeft,
                    child: Text('Group Description'),),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 140, // <-- TextField height
                    child:
                    TextField(
                      controller: groupDescriptionController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'A Short Description',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 150,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: createGroup,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Text(
                      'Create Group',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ]
            ),
        )
    );
  }
}