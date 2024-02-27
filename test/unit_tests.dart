import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:ensemble/features/group/repository/group_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:ensemble/core/failure.dart';
import 'package:ensemble/models/group_model.dart';

Future<void> main() async {
  final instance = FakeFirebaseFirestore();
  await instance.collection('users').add({
    'name': 'Bob',
  });
  final snapshot = await instance.collection('users').get();
  print(snapshot.docs.length); // 1
  print(snapshot.docs.first.get('username')); // 'Bob'
  print(instance.dump());
}