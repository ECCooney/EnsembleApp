import 'package:ensemble/features/booking/screens/booking_request_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../theme/pallete.dart';
import '../../nav/nav_drawer.dart';
import '../../user/controller/user_controller.dart';
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Pending Requests',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Pallete.orangeCustomColor),
            ),
          ),
          Divider(),
          const SizedBox(height: 10),
          Expanded(
            child: ref.watch(getRequests(uid)).when(
              data: (bookings) {
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    final booking = bookings[index];
                    final formattedBookingStart =
                    DateFormat('dd/MM/yy').format(booking.bookingStart);
                    final formattedBookingEnd =
                    DateFormat('dd/MM/yy').format(booking.bookingEnd);
                    return GestureDetector(
                      onTap: () =>  Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingRequestDetails(id: booking.id),
                        ),
                      ),
                      child: ListTile(
                        title: Text('Booking Request for: ${booking.itemName}'),
                        subtitle: Text('For pickup on: $formattedBookingStart, Drop-off on $formattedBookingEnd'),
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