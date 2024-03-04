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
    super.key,
    required this.uid,});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Booking Details'),
        ),
        drawer: const NavDrawer(),
        body: ref.watch(getUserBookingsProvider(uid)).when(
          data: (bookings) {
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                final booking = bookings[index];
                return ListTile(
                  title: Text('Booking Request for: ${booking.itemName}'),
                  subtitle: Text('Status: ${booking.bookingStatus}'),
                  leading: ref.watch(getItemByIdProvider(booking.itemId)).when(
                    data: (item) {
                      // Display user details
                      return CircleAvatar (
                        backgroundImage : NetworkImage(item.itemPic),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    // Show loading indicator while fetching user details
                    error: (error, stackTrace) =>
                        ErrorText(
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
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        )
    ) ;
  }
}
