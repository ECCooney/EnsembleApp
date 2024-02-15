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
import '../controller/booking_controller.dart';

class CreateBookingScreen extends ConsumerStatefulWidget {
  final String id;
  const CreateBookingScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {


  //https://javeedishaq.medium.com/understanding-the-dispose-method-in-flutter-e96d9a19442a#:~:text=In%20Flutter%2C%20the%20dispose%20method,can%20be%20safely%20cleaned%20up.
  @override


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
          : ref.watch(getBookingByIdProvider(widget.id)).when(
        data: (item) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // const Align(
                //   alignment: Alignment.topLeft,
                //   child: Text('Item Name'),
                // ),
                // const SizedBox(height: 10,),
                // TextField(
                //   controller: itemNameController,
                //   decoration: const InputDecoration(
                //     hintText: 'My Item Name',
                //     filled: true,
                //     border: InputBorder.none,
                //     contentPadding: EdgeInsets.all(18),
                //   ),
                //   maxLength: 30,
                // ),
                //
                // const SizedBox(height: 20),
                // const Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(
                //     'Select Category',
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: DropdownButton(
                //     value: category ?? categories[0],
                //     items: categories
                //         .map(
                //           (e) => DropdownMenuItem(
                //         value: e,
                //         child: Text(e), // Changed 'category' to e
                //       ),
                //     )
                //         .toList(),
                //     onChanged: (val) {
                //       setState(() {
                //         category = val;
                //       });
                //     },
                //   ),
                // ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Add Booking',
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