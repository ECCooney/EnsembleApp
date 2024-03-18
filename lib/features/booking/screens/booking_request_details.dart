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

  final locationController = TextEditingController();
  final pickupTimeController = TextEditingController();
  final dropoffTimeController = TextEditingController();
  void approveBooking(BookingModel booking) {
    ref.read(bookingControllerProvider.notifier).approveBooking(
      pickupLocation: locationController.text.trim(),
      bookingStatus: 'Confirmed',
      context: context,
      booking: booking,
      pickupTime: pickupTimeController.text.trim(),
      dropoffTime: dropoffTimeController.text.trim(),
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
  void dispose() {
    pickupTimeController.dispose();
    locationController.dispose();
    dropoffTimeController.dispose();
    super.dispose();
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
              const SizedBox(height: 16), // Add some space
              // Container to wrap text fields
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    // Text input field for pickup location
                    TextField(
                      controller: pickupTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Pick Up Time',
                        hintText: 'From : To',
                      ),
                    ),
                    TextField(
                      controller: dropoffTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Drop off Time',
                        hintText: 'From : To',
                      ),
                    ),
                    const SizedBox(height: 16), // Add some space
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Pickup Location',
                        hintText: 'Enter pickup location',
                      ),
                    ),
                  ],
                ),
              ),
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