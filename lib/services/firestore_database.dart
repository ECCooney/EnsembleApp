import 'dart:async';

import 'package:ensemble/models/item_model.dart';
import 'package:ensemble/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ensemble/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/*
This is the main class access/call for any UI widgets that require to perform
any CRUD activities operation in FirebaseFirestore database.
This class work hand-in-hand with FirestoreService and FirestorePath.

Notes:
For cases where you need to have a special method such as bulk update specifically
on a field, then is ok to use custom code and write it here. For example,
setAllItemComplete is require to change all items item to have the complete status
changed to true.

 */
class FirestoreDatabase {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _firestoreService = FirestoreService.instance;

  //Method to create/update itemModel
  Future<void> setItem(ItemModel item) async => await _firestoreService.set(
    path: FirestorePath.item(uid, item.id),
    data: item.toMap(),
  );

  //Method to delete itemModel entry
  Future<void> deleteItem(ItemModel item) async {
    await _firestoreService.deleteData(path: FirestorePath.item(uid, item.id));
  }

  //Method to retrieve itemModel object based on the given itemId
  Stream<ItemModel> itemStream({required String itemId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.item(uid, itemId),
        builder: (data, documentId) => ItemModel.fromMap(data, documentId),
      );

  //Method to retrieve all items item from the same user based on uid
  Stream<List<ItemModel>> itemsStream() => _firestoreService.collectionStream(
    path: FirestorePath.items(uid),
    builder: (data, documentId) => ItemModel.fromMap(data, documentId),
  );

  //Method to mark all itemModel to be complete
  Future<void> setAllItemComplete() async {
    final batchUpdate = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.items(uid))
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      batchUpdate.update(ds.reference, {'complete': true});
    }
    await batchUpdate.commit();
  }

  Future<void> deleteAllItemWithComplete() async {
    final batchDelete = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.items(uid))
        .where('complete', isEqualTo: true)
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      batchDelete.delete(ds.reference);
    }
    await batchDelete.commit();
  }
}