import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensemble/core/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/user_model.dart';

// Provider: This is a function that takes a callback as an argument. The callback is executed when the provider is accessed, and it is responsible for creating and providing the value.
//
// The callback function takes a single argument, ref, which stands for "ProviderReference." The ref parameter allows you to read other providers.
//
// Inside the callback function, an instance of AuthRepository is created by passing various dependencies:
//
// firestore: ref.read(firestoreProvider): It reads the value of a provider named firestoreProvider and passes it as the firestore parameter to the AuthRepository constructor. This suggests that firestoreProvider is another provider responsible for providing a Firestore instance.

final authRepositoryProvider = Provider(
      (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  //get info from firebase if user logs out
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        if (isFromLogin) {
          userCredential = await _auth.signInWithCredential(credential);
        } else {
          userCredential = await _auth.currentUser!.linkWithCredential(credential);
        }
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          email: userCredential.user!.email?? 'No Email',
          uid: userCredential.user!.uid,
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //go to user, get snapshot of the data, map it to the user model and return it. Will also be used
  //to persist the state of the application. Can also be used to view other users profile data (on wishlist)
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }


  // Future<void> signUpWithEmailAndPassword(
  //     String email,
  //     String password,
  //     String name,
  //     String profilePic,
  //     BuildContext context) async {
  //   try {
  //     _auth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((currentUser) => FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.user?.uid)
  //         .set({
  //       "uid": currentUser.user?.uid,
  //       "email": email,
  //       "password": password,
  //       "name": name,
  //       "profilePic": profilePic,
  //     }));
  //   } on FirebaseAuthException catch (e) {
  //     await showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //           title: Text('Error Occurred'),
  //           content: Text(e.toString()),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(ctx).pop();
  //                 },
  //                 child: Text("OK"))
  //           ],
  //         ));
  //   } catch (e) {
  //     // Dedicated message if an email is repeated.
  //     if (e == 'email-already-in-use') {
  //       print('Email already in use');
  //     } else {
  //       print('Error: $e');
  //     }
  //   }
  // }
  //
  // Future<void> loginWithEmailAndPassword(
  //     String email, String password, BuildContext context) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     await showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //             title: const Text("Error Occurred"),
  //             content: Text(e.toString()),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: const Text("OK"))
  //             ]));
  //   }
  // }
  void signOut() async {
    await _auth.signOut();
    print('signout');
  }
}