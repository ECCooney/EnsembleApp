import 'package:ensemble/core/common/google_sign_in_button.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/auth/repository/auth_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:ensemble/core/common/custom_text_field.dart';
import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/theme/pallete.dart';

import '../../../core/common/error_text.dart';
import '../../../models/group_model.dart';
import '../controller/group_controller.dart';

class JoinGroupScreen extends ConsumerStatefulWidget {

  final String id;
  const JoinGroupScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {

  final inviteCodeController = TextEditingController();


  void joinGroup(WidgetRef ref, GroupModel group, String inviteCode, BuildContext context) {
    ref.read(groupControllerProvider.notifier).joinGroup(group, inviteCodeController.text, context);
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final GlobalKey<FormState> _formKey = GlobalKey();
    final isLoading = ref.watch(authControllerProvider);

    // TextEditingControllers for data inputs

    return Scaffold(
      body: ref.watch(getGroupByIdProvider(widget.id)).when(
        data: (group) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(group.groupBanner, fit: BoxFit.cover,)
                    ),
                  ],
                ),
              ),
              SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(group.groupPic),
                              radius: 30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(group.name,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            OutlinedButton(
                              onPressed: () {
                                joinGroup(ref, group, group.inviteCode, context);
                                Navigator.pop(context); // Pop the context after joining the group
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: BorderSide(color: Pallete.orangeCustomColor),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text(
                                'Join now',
                                style: TextStyle(
                                  color: Pallete.blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                      ])
                  )

              )

            ];
          },
          body:  Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              icon: const Icon(Icons.password),
              controller: inviteCodeController,
              hintText: 'Enter the Provided Code',
              validator: (val){
                if (val!=group.inviteCode) {
                  return "Invalid Code";
                } else {
                  return null;
                }
              },
            ),
          ),
        ), error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }

}
