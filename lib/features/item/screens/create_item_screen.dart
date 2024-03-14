import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/theme/pallete.dart';

import '../../../core/common/error_text.dart';
import '../../../core/utils.dart';
import '../../../theme/borders.dart';
import '../../auth/controller/auth_controller.dart';
import '../../group/controller/group_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/item_controller.dart';
import '../../../models/group_model.dart';

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

  List<String> categories = ['DIY', 'Household', 'Clothing', 'Family', 'Other'];
  String? category;

  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemCategoryController = TextEditingController();

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
        category: category ?? categories[0],
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
        title: const Text('Create an Item'),
      ),
      drawer: const NavDrawer(),
      body: isLoading
          ? const Loader()
          : ref.watch(getGroupByIdProvider(widget.id)).when(
        data: (group) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      hintText: 'My Item Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: Borders.outlinedBorder,
                      focusedBorder: Borders.focusedBorder,
                      enabledBorder: Borders.enabledBorder,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Select Category',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: Borders.outlinedBorder,
                          focusedBorder: Borders.focusedBorder,
                          enabledBorder: Borders.enabledBorder,
                        ),
                        child: DropdownButton(
                          value: category ?? categories[0],
                          underline: SizedBox(), // Hides the default underline
                          isExpanded: true,
                          items: categories
                              .map(
                                (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              category = val;
                            });
                          },
                        ),
                      ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Item Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 140,
                    child: TextField(
                      controller: itemDescriptionController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'A Short Description',
                        filled: true,
                        fillColor: Colors.white,
                        border: Borders.outlinedBorder,
                        focusedBorder: Borders.focusedBorder,
                        enabledBorder: Borders.enabledBorder,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 150,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => createItem(group),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Pallete.orangeCustomColor,
                    ),
                    child: const Text(
                      'Create Item',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
      ),
    );
  }
}