import 'package:ensemble/models/booking_model.dart';
import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/type_defs.dart';
import '../../../models/item_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../booking/controller/booking_controller.dart';
import '../controller/item_controller.dart';
import 'package:booking_calendar/booking_calendar.dart';

class ItemScreen extends ConsumerStatefulWidget {

  final String id;
  const ItemScreen({
    required this.id,
    super.key});

  void navigateToEditItem(BuildContext context) {
    Routemaster.of(context).push('/edit_item/$id');
  }

  @override
  ConsumerState createState() => _ItemScreenState();
}


class _ItemScreenState extends ConsumerState<ItemScreen> {
  late DateTime today = DateTime.now();
  late DateTime _bookingStart;
  late DateTime _bookingEnd;

  List<DateTime> blackoutDates = <DateTime>[];


  @override
  initState(){
    super.initState();
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value!;
      _bookingStart = range.startDate!;
      _bookingEnd = range.endDate!;
    }
  }

  createBooking(ItemModel item) {
    ref.read(bookingControllerProvider.notifier).createBooking(
      bookingStart: _bookingStart,
      bookingEnd: _bookingEnd,
      bookingStatus: 'Pending',
      item: item,
      context: context,
    );
  }

  //support.syncfusion.com/kb/article/10751/how-to-update-blackout-dates-in-the-flutter-date-range-picker

   Future <List<DateTime>> getDates(ItemModel item) async {
    var id = item.id;
    var bookings = ref.watch(getItemBookingsProvider(id));
    List<DateTime> blackoutDates = <DateTime>[];

    // Check the state of the AsyncValue
    bookings.when(
      data: (bookings) {

        for (var booking in bookings) {

          final bookingStart = booking.bookingStart;
          final bookingEnd = booking.bookingEnd;

          final bookingRange = List<DateTime>.generate(
            (bookingEnd.difference(bookingStart).inDays + 1),
                (index) => bookingStart.add(Duration(days: index)),
          );
          blackoutDates.add(today);
          blackoutDates.addAll(bookingRange);
        }
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString(),),
    );
    return blackoutDates;
  }


  DateRangePickerController _datePickerController = DateRangePickerController();


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: ref.watch(getItemByIdProvider(widget.id)).when(
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
                              item.itemPic, fit: BoxFit.cover,)
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              onPressed: () {
                              },
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
                      ]),
                    ),
                  ),
                ];
              },
              body: ref.watch(getItemBookingsProvider(widget.id)).when(
                data: (bookings) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 400,
                        child: SfDateRangePicker(
                          initialSelectedDate: DateTime.now(),
                          view: DateRangePickerView.month,
                          monthViewSettings: DateRangePickerMonthViewSettings(
                              blackoutDates: blackoutDates),
                          monthCellStyle: const DateRangePickerMonthCellStyle(blackoutDateTextStyle:
                          TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough),
                          ),
                          selectionMode: DateRangePickerSelectionMode.range,
                          selectionColor: Pallete.sageCustomColor,
                          onSelectionChanged: selectionChanged,
                          showActionButtons: true,
                          onSubmit: (bookings) {
                            createBooking(item);
                            Navigator.pop(context);
                          },
                          // onViewChanged: viewChanged,
                          onCancel: () {
                            _datePickerController.selectedRanges = null;
                          },
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              ),
            ), error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
  }