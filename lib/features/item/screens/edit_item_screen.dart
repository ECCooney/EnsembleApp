import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils.dart';
import '../../../models/item_model.dart';
import '../../nav/nav_drawer.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/item_controller.dart';
import 'package:intl/intl.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  final String id;
  const EditItemScreen({
    required this.id,
    super.key,
  });

  @override
  ConsumerState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  File? itemPicFile;
  final itemDescriptionController = TextEditingController();
  final itemNameController = TextEditingController();

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
      name: itemNameController.text.trim(),
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
  void dispose() {
    itemDescriptionController.dispose();
    itemNameController.dispose();
    super.dispose();
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
          ],
        ),
        drawer: const NavDrawer(),
        body: isLoading
            ? const Loader()
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: chooseItemImage,
                        child: itemPicFile != null
                            ? CircleAvatar(
                          backgroundImage: FileImage(itemPicFile!),
                          radius: 32,
                        )
                            : CircleAvatar(
                          backgroundImage: NetworkImage(item.itemPic),
                          radius: 32,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 20,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              saveEdit(item);
                            },
                            icon: Icon(Icons.save),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteItem(item);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  hintText: item.name,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              SizedBox(
                height: 140, // <-- TextField height
                child: TextField(
                  controller: itemDescriptionController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: item.description,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 150,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Item Booking History:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: ref.watch(getItemBookingsProvider(widget.id)).when(
                  data: (bookings) {
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final booking = bookings[index];
                        final userAsyncValue = ref.watch(getUserDataProvider(booking.requester));
                        return ListTile(
                          // Use a conditional expression to check the state of userAsyncValue
                          title: userAsyncValue.when(
                            // When data is available, use user.name as the title
                            data: (user) => Text(user.name),
                            loading: () => const Text('Loading...'),
                            // When error occurs, display an error message
                            error: (error, stackTrace) => const Text('Error'),
                          ),
                          subtitle: userAsyncValue.when(
                            data: (user) {
                              final startDate = DateFormat('dd/MM/yy').format(booking.bookingStart);
                              final endDate = DateFormat('dd/MM/yy').format(booking.bookingEnd);
                              return Text(
                                'Booked from $startDate to $endDate\nStatus: ${booking.bookingStatus}',
                                // Adjust the style and format according to your preference
                              );
                            },
                            loading: () => const Text('Loading...'), // Show loading message while data is loading
                            error: (error, stackTrace) => const Text('Error'), // Handle error state
                          ),
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
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
    );
  }
}