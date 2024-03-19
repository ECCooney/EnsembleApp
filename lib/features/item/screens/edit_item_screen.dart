import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils.dart';
import '../../../models/item_model.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/item_controller.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Edit Item'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () => saveEdit(item),
              child: const Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        drawer: const NavDrawer(),
        body: isLoading
            ? const Loader()
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: chooseItemImage,
                              child: itemPicFile != null
                                  ? CircleAvatar(
                                backgroundImage: FileImage(itemPicFile!),
                                radius: 72,
                              )
                                  : CircleAvatar(
                                backgroundImage: NetworkImage(item.itemPic),
                                radius: 90,
                              ),
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Item Name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: itemNameController,
                        decoration: InputDecoration(
                          hintText: item.name,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Item Description',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: itemDescriptionController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: item.description,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => saveEdit(item),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: BorderSide(color: Pallete.orangeCustomColor),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Optional spacing between buttons
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                deleteItem(item);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallete.orangeCustomColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Pallete.whiteColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Item Booking History:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 200,
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