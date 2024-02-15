import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/booking_model.dart';
import '../../../models/group_model.dart';
import '../../../models/item_model.dart';

final itemRepositoryProvider = Provider((ref) {
  return ItemRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class ItemRepository {
  final FirebaseFirestore _firestore;
  ItemRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _items => _firestore.collection(FirebaseConstants.itemsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addItem(ItemModel item) async {
    try {
      return right(_items.doc(item.id).set(item.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<BookingModel>> getItemBookings(String id) {
    return _bookings.where('itemId', isEqualTo: id).snapshots().map(
          (event) => event.docs
          .map(
            (e) => BookingModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Stream<List<ItemModel>> getItems(List<GroupModel> groups) {
    return _items
        .where('id', whereIn: groups.map((e) => e.id).toList())
        .snapshots()
        .map(
          (event) => event.docs
          .map(
            (e) => ItemModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  FutureVoid editItem(ItemModel item) async {
    try {
      return right(_items.doc(item.id).update(item.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  FutureVoid deleteItem(ItemModel item) async {
    try {
      return right(_items.doc(item.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<ItemModel> getItemById(String id) {
    return _items.doc(id).snapshots().map((event) => ItemModel.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _bookings => _firestore.collection(FirebaseConstants.bookingsCollection);

}