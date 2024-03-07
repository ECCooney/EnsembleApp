import 'package:ensemble/features/booking/screens/booking_request_details.dart';
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

class BookingRequests extends ConsumerWidget {

  final String uid;

  const BookingRequests({
    super.key,
    required this.uid,});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Requests'),
      ),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Booking Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ref.watch(getRequests(uid)).when(
              data: (bookings) {
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    final booking = bookings[index];
                    return ListTile(
                      title: Text('Booking Request for: ${booking.itemName}'),
                      subtitle: Text('Status: ${booking.bookingStatus}'),
                      trailing: IconButton(
                        icon: Icon(Icons.open_in_new),
                        onPressed: () {
                          // Navigate to a new route when IconButton is pressed
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingRequestDetails(id: booking.id),
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
            ),
          ),
        ],
      ),
    );
  }
}
