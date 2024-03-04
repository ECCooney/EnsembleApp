import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ensemble/core/constants/firebase_constants.dart';
import 'package:ensemble/core/failure.dart';
import 'package:ensemble/core/type_defs.dart';
import '../../../models/item_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';

final messageRepositoryProvider = Provider
  ((ref) {
  return MessageRepository(firestore: ref.watch(firestoreProvider));
});


class MessageRepository {
  final FirebaseFirestore _firestore;
  MessageRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _messages => _firestore.collection(FirebaseConstants.messagesCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addMessage(MessageModel message) async {
    try {
      return right(_messages.doc(message.id).set(message.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<MessageModel>> getMessages(List<GroupModel> groups) {
    return _messages
        .where('groupId', whereIn: groups.map((e) => e.id).toList())
        .snapshots()
        .map(
          (event) => event.docs
          .map(
            (e) => MessageModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  FutureVoid deleteMessage(MessageModel message) async {
    try {
      return right(_messages.doc(message.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addResponse(MessageModel message) async {
    try {
      return right(_messages.doc(message.id).update(message.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid changeToRead(MessageModel message) async {
    try {
      return right(_messages.doc(message.id).update(message.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<MessageModel>> getGroupMessages(String id) {
    return _messages.where('groupId', isEqualTo: id).snapshots().map(
          (event) => event.docs
          .map(
            (e) => MessageModel.fromMap(
          e.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }


  Stream<MessageModel> getMessageById(String id) {
    return _messages.doc(id).snapshots().map((event) => MessageModel.fromMap(event.data() as Map<String, dynamic>));
  }

}