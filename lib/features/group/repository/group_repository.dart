import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ensemble/core/constants/firebase_constants.dart';
import 'package:ensemble/core/failure.dart';
import 'package:ensemble/core/type_defs.dart';

import '../../../models/item_model.dart';

final groupRepositoryProvider = Provider
  ((ref) {
  return GroupRepository(firestore: ref.watch(firestoreProvider));
});

class GroupRepository {
  final FirebaseFirestore _firestore;
  GroupRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureVoid createGroup(GroupModel group) async {
    try{
      return right(_groups.doc(group.id).set(group.toMap()));

    }on FirebaseException catch (e){
      throw e.message!;
    }
    catch (e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<GroupModel>> getUserGroups(String uid) {
    return _groups.where('members', arrayContains: uid).snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var doc in event.docs) {
        groups.add(GroupModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return groups;
    });
  }

  Stream<GroupModel> getGroupById(String id) {
    return _groups.doc(id).snapshots().map((event) => GroupModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editGroup(GroupModel group) async {
    try {
      return right(_groups.doc(group.id).update(group.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteGroup(GroupModel group) async {
    try {
      return right(_groups.doc(group.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ItemModel>> getGroupItems(String id) {
    return _items.where('groupId', isEqualTo: id).snapshots().map(
          (event) => event.docs
          .map(
            (e) => ItemModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  CollectionReference get _items => _firestore.collection(FirebaseConstants.itemsCollection);

  CollectionReference get _groups => _firestore.collection(FirebaseConstants.groupsCollection);
}