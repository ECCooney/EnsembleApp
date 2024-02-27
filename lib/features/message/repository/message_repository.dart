import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ensemble/core/constants/firebase_constants.dart';
import 'package:ensemble/core/failure.dart';
import 'package:ensemble/core/type_defs.dart';
import '../../../models/item_message_model.dart';
import '../../../models/item_model.dart';
import '../../../models/user_model.dart';

final messageRepositoryProvider = Provider
  ((ref) {
  return MessageRepository(firestore: ref.watch(firestoreProvider));
});


class MessageRepository {
  final FirebaseFirestore _firestore;
  MessageRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _itemMessages => _firestore.collection(FirebaseConstants.itemMessagesCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addItemMessage(ItemMessageModel itemMessage) async {
    try {
      return right(_itemMessages.doc(itemMessage.id).set(itemMessage.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ItemMessageModel>> getItemMessages(List<ItemModel> items) {
    return _itemMessages
        .where('itemId', whereIn: items.map((e) => e.id).toList())
        .snapshots()
        .map(
          (event) => event.docs
          .map(
            (e) => ItemMessageModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  FutureVoid deleteItemMessage(ItemMessageModel itemMessage) async {
    try {
      return right(_itemMessages.doc(itemMessage.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<ItemMessageModel> getItemMessageById(String id) {
    return _itemMessages.doc(id).snapshots().map((event) => ItemMessageModel.fromMap(event.data() as Map<String, dynamic>));
  }

}