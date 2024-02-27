import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_providers.dart';
import '../../../core/utils.dart';
import '../../../models/booking_model.dart';
import '../../../models/item_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/booking_repository.dart';

final bookingsProvider = StreamProvider.family((ref, List<ItemModel> items) {
  final bookingController = ref.watch(bookingControllerProvider.notifier);
  return bookingController.getBookings(items);
});

final bookingControllerProvider = StateNotifierProvider<BookingController, bool>((ref) {
  final bookingRepository = ref.watch(bookingRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return BookingController(bookingRepository: bookingRepository, ref: ref, storageRepository: storageRepository);
});

final getBookingByIdProvider = StreamProvider.family((ref, String id) {
  final bookingController = ref.watch(bookingControllerProvider.notifier);
  return bookingController.getBookingById(id);
});

class BookingController extends StateNotifier<bool> {
  final BookingRepository _bookingRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  BookingController({
    required BookingRepository bookingRepository,
    required Ref ref,
    required StorageRepository storageRepository
  }): _bookingRepository = bookingRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createBooking({
    required BuildContext context,
    required DateTime bookingStart,
    required DateTime bookingEnd,
    required String bookingStatus,
    required ItemModel item

  }) async {
    state = true;
    String bookingId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final BookingModel booking = BookingModel(
      id: bookingId,
      bookingStart: bookingStart,
      bookingEnd: bookingEnd,
      bookingStatus: bookingStatus,
      itemId: item.id,
      itemName: item.name,
      itemOwner: item.owner,
      requester: user.uid,
    );

    final res = await _bookingRepository.addBooking(booking);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Added successfully!');
      Routemaster.of(context).pop();
    });
  }

  void editBooking({
    required String? bookingStatus,
    required BuildContext context,
    required BookingModel booking,
  }) async {

    if (bookingStatus != null) {
      booking = booking.copyWith(bookingStatus: bookingStatus);
    }
    final res = await _bookingRepository.editBooking(booking);

    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => Routemaster.of(context).pop(),
    );
  }


  Stream<List<BookingModel>> getBookings(List<ItemModel> items) {
    if (items.isNotEmpty) {
      return _bookingRepository.getBookings(items);
    }
    return Stream.value([]);
  }



  void deleteBooking(BookingModel booking, BuildContext context) async {
    final res = await _bookingRepository.deleteBooking(booking);
    res.fold((l) => null, (r) => showSnackBar(context, 'Booking Deleted successfully!'));
  }


  Stream<BookingModel> getBookingById(String id) {
    return _bookingRepository.getBookingById(id);
  }
}