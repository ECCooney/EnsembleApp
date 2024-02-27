import 'dart:io';
import 'package:ensemble/core/utils.dart';
import 'package:ensemble/features/item/controller/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../models/item_model.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  final String id;
  const EditItemScreen({
    required this.id,
    super.key});

  @override
  ConsumerState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {

  File? itemPicFile;

  final itemDescriptionController = TextEditingController();


  void chooseItemImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        itemPicFile = File(res.files.first.path!);
      });
    }
  }

  void saveEdit(ItemModel item) {
    ref.read(itemControllerProvider.notifier).editItem(
      itemPicFile: itemPicFile,
      description: itemDescriptionController.text.trim(),
      context: context,
      item: item,
    );
  }

  void deleteItem(ItemModel item) {
    ref.read(itemControllerProvider.notifier).deleteItem(item, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(itemControllerProvider);
    return ref.watch(getItemByIdProvider(widget.id)).when(
      data: (item) => Scaffold(
        appBar: AppBar(
            title: const Text('Edit Item'),
            centerTitle: false,
            actions: [
              TextButton(onPressed: () => saveEdit(item), child: const Text('Save')),
            ]
        ),
        body: isLoading
            ? const Loader()
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: chooseItemImage,
                          child: itemPicFile!=null?
                          CircleAvatar(
                            backgroundImage: FileImage(itemPicFile!),
                            radius: 32,
                          )
                              : CircleAvatar(
                            backgroundImage: NetworkImage(item.itemPic),
                            radius: 32,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 140, // <-- TextField height
                  child:
                  TextField(
                    controller: itemDescriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Add a New Description',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 150,
                  ),
                ),
                TextButton(
                  onPressed: () => deleteItem(item),
                  child: const Text('Delete Item'),
                ),
                Expanded(
                  child: ref.watch(getItemBookingsProvider(widget.id)).when(
                    data: (bookings) {
                      return ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (BuildContext context, int index) {
                          final booking = bookings[index];
                          return ListTile(
                            title: Text(booking.itemName),
                            subtitle: Text (booking.requester),
                            trailing: Text (booking.bookingStart.toString()),
                            onTap: () {},
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
    );
  }
}
