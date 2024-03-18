import 'package:ensemble/features/item/controller/item_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../nav/nav_drawer.dart';
import '../../user/controller/user_controller.dart';
import 'booking_details.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  final String uid;
  const BookingsScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  final List<String> statuses = ['Request Denied', 'Confirmed', 'Pending'];
  List <String> selectedStatuses = [];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'My Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: statuses.map((status) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust spacing as needed
                child: FilterChip(
                  selected: selectedStatuses.contains(status),
                  label: Text(status),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedStatuses.add(status);
                      } else {
                        selectedStatuses.remove(status);
                      }
                    });
                  },
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: ref.watch(getUserBookingsProvider(widget.uid)).when(
              data: (bookings) {
                final filteredBookings = bookings.where((booking) {
                  return selectedStatuses.isEmpty|| selectedStatuses.contains(booking.bookingStatus);
                }).toList();
                return ListView.builder(
                  itemCount: filteredBookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    final booking = filteredBookings[index];
                      return ListTile(
                        title: Text('Booking for: ${booking.itemName}'),
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