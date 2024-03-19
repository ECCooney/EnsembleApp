import 'package:ensemble/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/booking_controller.dart';

class BookingDetails extends ConsumerStatefulWidget {
  final String id;
  const BookingDetails({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends ConsumerState<BookingDetails> {
  void cancelBooking(BookingModel booking) {
    ref.read(bookingControllerProvider.notifier).cancelBooking(booking, context);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getBookingByIdProvider(widget.id)).when(
      data: (booking) => Scaffold(
        appBar: AppBar(
          title: const Text('Booking Details'),
          centerTitle: false,
          actions: [
           IconButton(
             onPressed:() {
               cancelBooking;
               Navigator.pop(context);
             } ,
             icon: Icon(Icons.delete, color: Pallete.blackColor), // Match the text color
            ),
          ],
        ),
        drawer: const NavDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Requester Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Requester',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Pallete.orangeCustomColor,
                  ),
                ),
              ),
              // Fetch user details using the booking.requester field
              ref.watch(getUserDataProvider(booking.requester)).when(
                data: (userData) {
                  // Display user details
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Name: ${userData.name}'),
                      Text('Email: ${userData.email}'), // Displaying user's email
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                // Show loading indicator while fetching user details
                error: (error, stackTrace) =>
                    ErrorText(
                      error: error.toString(),
                    ),
              ),
              Divider(),
              // Booking Details Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Pallete.orangeCustomColor,
                  ),
                ),
              ),
              Text(
                '${booking.itemName} booked from: ${DateFormat('dd/MM/yyyy').format(booking.bookingStart)} to ${DateFormat('dd/MM/yyyy').format(booking.bookingEnd)}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Pickup Time: ${booking.pickupTime}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Drop off Time: ${booking.dropoffTime}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Pickup Location: ${booking.pickupLocation}',
                style: TextStyle(fontSize: 14),
              ),
              // Display booking details
              Spacer(),
              ElevatedButton(
                onPressed:() {
                  cancelBooking;
                  Navigator.pop(context);
                } ,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Pallete.orangeCustomColor, // Change the button color to orange
                ),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) =>
          ErrorText(
            error: error.toString(),
          ),
    );
  }
}