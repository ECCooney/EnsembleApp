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
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {

  final FirebaseFirestore _firestore;
  UserRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _groups => _firestore.collection(FirebaseConstants.groupsCollection);
  CollectionReference get _items => _firestore.collection(FirebaseConstants.itemsCollection);
  CollectionReference get _itemMessages => _firestore.collection(FirebaseConstants.messagesCollection);
  CollectionReference get _bookings => _firestore.collection(FirebaseConstants.bookingsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ItemModel>> getUserItems(String uid) {
    return _items.where('owner', isEqualTo: uid).snapshots().map(
          (event) => event.docs
          .map(
            (e) => ItemModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Stream<List<MessageModel>> getUserSentMessages(String uid) {
    return _itemMessages.where('senderId', isEqualTo: uid).snapshots().map(
          (event) => event.docs
          .map(
            (e) => MessageModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Stream<List<BookingModel>> getUserBookings(String uid) {
    return _bookings.where('requester', isEqualTo: uid).snapshots().map(
          (event) => event.docs
          .map(
            (e) => BookingModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Stream<List<GroupModel>> getGroups(String uid) {
    return _groups.where('members', arrayContains: uid).snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var doc in event.docs) {
        groups.add(GroupModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return groups;
    });
  }

  Stream<List<BookingModel>> getRequests(String uid) {
    return _bookings
        .where('itemOwner', isEqualTo: uid)
        .where('bookingStatus', isEqualTo: 'Pending') // Filter by bookingStatus
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
}