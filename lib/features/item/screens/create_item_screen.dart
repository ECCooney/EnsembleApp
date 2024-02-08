import 'dart:io';
import 'package:ensemble/features/group/controller/group_controller.dart';
import 'package:ensemble/features/item/controller/item_controller.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:ensemble/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/loader.dart';

import '../../../core/common/error_text.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';

class CreateItemScreen extends ConsumerStatefulWidget {
  final String id;
  const CreateItemScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends ConsumerState<CreateItemScreen> {
  File? itemPicFile;

  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemCategoryController = TextEditingController();

  //https://javeedishaq.medium.com/understanding-the-dispose-method-in-flutter-e96d9a19442a#:~:text=In%20Flutter%2C%20the%20dispose%20method,can%20be%20safely%20cleaned%20up.
  @override
  void dispose() {
    super.dispose();
    itemNameController.dispose();
    itemDescriptionController.dispose();
  }

  void chooseItemPic() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        itemPicFile = File(res.files.first.path!);
      });
    }
  }

  void createItem(GroupModel group) {
    if (itemNameController.text.isNotEmpty) {
      ref.read(itemControllerProvider.notifier).createItem(
        context: context,
        name: itemNameController.text.trim(),
        description: itemDescriptionController.text.trim(),
        category: itemCategoryController.text.trim(),
        group: group,
      );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(itemControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Item'),
      ),
      body: isLoading
          ? const Loader()
          : ref.watch(getGroupByIdProvider(widget.id)).when(
        data: (group) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Item Name'),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                    hintText: 'My Item Name',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: itemCategoryController,
                  decoration: const InputDecoration(
                    hintText: 'Add a Category',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Item Description'),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 140, // <-- TextField height
                  child: TextField(
                    controller: itemDescriptionController,
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
                  onPressed: () => createItem(group),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Create Item',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          );
        }, loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
      ),
    );
  }
}