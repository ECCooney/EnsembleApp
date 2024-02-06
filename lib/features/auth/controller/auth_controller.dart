import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/core/utils.dart';
import 'package:ensemble/models/user_model.dart';
import 'package:ensemble/features/auth/repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
      (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);


final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

//

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});


//extends StateNotifier to notify all providers listening. This here represents isLoading so we pass in a boolean
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading

  //user below comes from firebaseAuth
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
          (l) => showSnackBar(context, l.message),
          (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signUpWithEmail(String name, String email, String password, String profilePic, BuildContext context) async {
    state = true;
    final user = await _authRepository.signUpWithEmail(email: email, password: password, context: context);
    state = false;
    user.fold(
          (l) => showSnackBar(context, l.message),
          (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void loginWithEmail(String email, String password, BuildContext context) async {
    await _authRepository.loginWithEmail(email: email, password: password, context: context);
  }


  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void signOut() async {
    _authRepository.signOut();
  }
}