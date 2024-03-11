import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/booking_controller.dart';

class BookingRequestDetails extends ConsumerStatefulWidget {
  final String id;

  const BookingRequestDetails({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState createState() => _BookingRequestDetailsState();
}

class _BookingRequestDetailsState extends ConsumerState<BookingRequestDetails> {
  void approveBooking(BookingModel booking) {
    ref.read(bookingControllerProvider.notifier).approveBooking(
      bookingStatus: 'Confirmed',
      context: context,
      booking: booking,
    );
  }

  void denyBooking(BookingModel booking) {
    ref.read(bookingControllerProvider.notifier).denyBooking(
      bookingStatus: 'Request Denied',
      context: context,
      booking: booking,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookingControllerProvider);

    return ref.watch(getBookingByIdProvider(widget.id)).when(
      data: (booking) => Scaffold(
        appBar: AppBar(
          title: const Text('Request Details'),
          centerTitle: false,
        ),
        drawer: const NavDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
              ),
              // Booking Details Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              // Display booking details
              Text('Item Name: ${booking.itemName}'),
              Text('Booking Start: ${booking.bookingStart}'),
              Text('Booking End: ${booking.bookingEnd}'),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => approveBooking(booking),
                child: const Text('Approve'),
              ),
              ElevatedButton(
                onPressed: () => denyBooking(booking),
                child: const Text('Cancel Request'),
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