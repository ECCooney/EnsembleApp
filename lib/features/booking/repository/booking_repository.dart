import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ensemble/core/constants/firebase_constants.dart';
import 'package:ensemble/core/failure.dart';
import 'package:ensemble/core/type_defs.dart';

import '../../../models/booking_model.dart';
import '../../../models/item_model.dart';

final bookingRepositoryProvider = Provider
  ((ref) {
  return BookingRepository(firestore: ref.watch(firestoreProvider));
});


class BookingRepository {
  final FirebaseFirestore _firestore;
  BookingRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _bookings => _firestore.collection(FirebaseConstants.bookingsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addBooking(BookingModel booking) async {
    try {
      return right(_bookings.doc(booking.id).set(booking.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //https://pub.dev/packages/booking_calendar
  List<DateTimeRange> convertStreamResultFirebase(
      {required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///Note that this is dynamic, so you need to know what properties are available on your result, in our case the [SportBooking] has bookingStart and bookingEnd property
    List<DateTimeRange> converted = [];
    for (var i = 0; i < streamResult.size; i++) {
      final booking = streamResult.docs[i].data();
      converted.add(DateTimeRange(start: (booking.bookingStart!), end: (booking.bookingEnd!)));
    }
    return converted;
  }


  Stream<List<BookingModel>> getBookings(List<ItemModel> items) {
    return _bookings
        .where('itemId', whereIn: items.map((e) => e.id).toList())
        .snapshots()
        .map(
          (event) => event.docs
          .map(
            (e) => BookingModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  FutureVoid approveBooking(BookingModel booking) async {
    try {
      return right(_bookings.doc(booking.id).update(booking.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  FutureVoid deleteBooking(BookingModel booking) async {
    try {
      return right(_bookings.doc(booking.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<BookingModel> getBookingById(String id) {
    return _bookings.doc(id).snapshots().map((event) => BookingModel.fromMap(event.data() as Map<String, dynamic>));
  }

}