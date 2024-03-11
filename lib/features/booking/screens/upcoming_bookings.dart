import 'package:ensemble/features/booking/screens/booking_request_details.dart';
import 'package:ensemble/features/item/controller/item_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../../user/controller/user_controller.dart';
import '../../user/repository/user_repository.dart';
import 'booking_details.dart';

class Bookings extends ConsumerWidget {
  final String uid;

  const Bookings({
    Key? key,
    required this.uid,
  }) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Bookings'),
      ),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'All Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                },
                child: Text('All'),
              ),
              ElevatedButton(
                onPressed: () {

                },
                child: Text('Upcoming'),
              ),
              ElevatedButton(
                onPressed: () {
                },
                child: Text('Completed'),
              ),
            ],
          ),
          Expanded(
            child: ref.watch(getUserBookingsProvider(uid)).when(
              data: (bookings) {
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    final booking = bookings[index];
                    if (booking.bookingStart.isAfter(DateTime.now())) {
                      return ListTile(
                        title: Text('Upcoming Booking for: ${booking.itemName}'),
                        subtitle: Text('Status: ${booking.bookingStatus}'),
                        leading: ref.watch(getItemByIdProvider(booking.itemId)).when(
                          data: (item) {
                            // Display user details
                            return CircleAvatar(
                              backgroundImage: NetworkImage(item.itemPic),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          // Show loading indicator while fetching user details
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () {
                            // Navigate to a new route when IconButton is pressed
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BookingDetails(id: booking.id),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox(); // Return an empty SizedBox for bookings in the past
                    }
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
    );
  }
}