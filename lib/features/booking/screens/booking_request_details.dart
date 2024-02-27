import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../controller/booking_controller.dart';

class BookingRequestDetails extends ConsumerStatefulWidget {

  final String id;
  const BookingRequestDetails({super.key, required this.id});

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
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookingControllerProvider);
    return ref.watch(getBookingByIdProvider(widget.id)).when(
      data: (booking) => Scaffold(
        appBar: AppBar(
            title: const Text('Request Details'),
            centerTitle: false,
            actions: [
              TextButton(onPressed: () => approveBooking(booking), child: const Text('Approve')),
            ]
        ),
        body: Column()
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
    );
  }
}
