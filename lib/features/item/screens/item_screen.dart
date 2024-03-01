import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/booking_model.dart';
import '../../../models/item_model.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../../booking/controller/booking_controller.dart';
import '../../message/controller/message_controller.dart';
import '../../nav/nav_drawer.dart';
import '../controller/item_controller.dart';

class ItemScreen extends ConsumerStatefulWidget {
  final String id;
  const ItemScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ItemScreenState();
}

class _ItemScreenState extends ConsumerState<ItemScreen> {
  late DateTime today = DateTime.now();
  late DateTime _bookingStart;
  late DateTime _bookingEnd;

  String bookingId = const Uuid().v1();

  Future <List<DateTime>>? _blackoutDatesFuture;


  void navigateToEditItem(BuildContext context) {
    Routemaster.of(context).push('/edit-item/${widget.id}');
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value!;
      _bookingStart = range.startDate!;
      _bookingEnd = range.endDate!;
    }
  }


  void createBooking(ItemModel item) {
    ref.read(bookingControllerProvider.notifier).createBooking(
      bookingStart: _bookingStart,
      bookingId: bookingId,
      bookingEnd: _bookingEnd,
      bookingStatus: 'Pending',
      item: item,
      context: context,
    );
  }



  // void createItemMessage(BookingModel booking) async {
  //   ItemModel item = await ref.watch(getItemByIdProvider(widget.id).future);
  //   ref.watch(getBookingByIdProvider(bookingId)).when(
  //     data: (booking) {
  //       ref.read(messageControllerProvider.notifier).createItemMessage(
  //         context: context,
  //         subject: "Booking Request", // Provide the subject for the message
  //         text: "A request has been submitted", // Provide the text for the message
  //         booking: booking,
  //       );
  //     },
  //     error: (error, stackTrace) => ErrorText(error: error.toString()),
  //     loading: () => Loader(),
  //   );
  // }

  Future<List<DateTime>> getDates() async {
    ItemModel item = await ref.watch(getItemByIdProvider(widget.id).future);
    var id = item.id;
    var bookings = ref.watch(getItemBookingsProvider(id));

    List<DateTime> blackoutDates = <DateTime>[];

    if (bookings != null) {
      bookings.when(
        data: (bookingsData) {
          for (var booking in bookingsData) {
            if (booking.bookingStatus == 'Confirmed') { // Filter by booking status
              final bookingStart = booking.bookingStart;
              final bookingEnd = booking.bookingEnd;

              final bookingRange = List<DateTime>.generate(
                (bookingEnd.difference(bookingStart).inDays + 1),
                    (index) => bookingStart.add(Duration(days: index)),
              );
              blackoutDates.addAll(bookingRange);
            }
          }
          blackoutDates.add(today);
        },
        error: (error, stackTrace) {
          print(error); // Print error for debugging purposes
          return ErrorText(error: error.toString());
        },
        loading: () => Loader(),
      );
    }
    // Return an empty list if bookings is null or no data is loaded yet
    return blackoutDates;
  }

  DateRangePickerController _datePickerController = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    // Execute getDates after the current frame is built
    //https://api.flutter.dev/flutter/scheduler/SchedulerBinding/addPostFrameCallback.html
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _blackoutDatesFuture = getDates();
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      drawer: const NavDrawer(),
      body: FutureBuilder<List<DateTime>>(
        future: _blackoutDatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader(); // Show a loader while waiting for data
          } else if (snapshot.hasError) {
            return ErrorText(
                error: snapshot.error.toString()); // Show error if any
          } else {
            List<DateTime> blackoutDates = snapshot.data ??
                []; // Use empty list if data is null
            return ref.watch(getItemByIdProvider(widget.id)).when(
              data: (item) =>
                  NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: 200,
                          floating: true,
                          snap: true,
                          flexibleSpace: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  item.itemPic,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  item.owner.contains(user.uid)
                                      ? OutlinedButton(
                                    onPressed: () =>
                                        navigateToEditItem(context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: const Text('Edit Item'),
                                  )
                                      : SizedBox(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ];
                    },
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 400,
                          child: Column(
                            children: [
                              SfDateRangePicker(
                                initialSelectedDate: today,
                                minDate: today,
                                enablePastDates: false,
                                view: DateRangePickerView.month,
                                monthViewSettings: DateRangePickerMonthViewSettings(
                                  blackoutDates: blackoutDates,
                                ),
                                monthCellStyle: const DateRangePickerMonthCellStyle(
                                  blackoutDateTextStyle: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                selectionMode: DateRangePickerSelectionMode
                                    .range,
                                selectionColor: Pallete.sageCustomColor,
                                onSelectionChanged: selectionChanged,
                                showActionButtons: true,
                                onSubmit: (bookings) {
                                  createBooking(item);
                                  Navigator.pop(context);
                                },
                                onCancel: () {
                                  _datePickerController.selectedRanges = null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => Loader(),
            );
          }
        },
      ),
    );
  }
}