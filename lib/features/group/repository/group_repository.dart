import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';

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

  CollectionReference get _groups => _firestore.collection(FirebaseConstants.groupsCollection);
}