import 'package:ensemble/models/booking_model.dart';
import 'package:ensemble/theme/pallete.dart';
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
  final DateTime _minDate = DateTime.now();
  DateTime _start = DateTime.now();

  @override
  initState(){
    super.initState();
  }


  createBooking(ItemModel item) {
    ref.read(bookingControllerProvider.notifier).createBooking(
      bookingStart: DateTime.now(),
      bookingEnd: DateTime.now(),
      bookingStatus: 'Pending',
      item: item,
      context: context,
    );
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
              // <-- Added closing bracket here
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
                          selectionMode: DateRangePickerSelectionMode.range,
                          selectionColor: Pallete.sageCustomColor,
                          showActionButtons: true,
                          onSubmit: (bookings) {
                            createBooking(item);
                            Navigator.pop(context);
                          },
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