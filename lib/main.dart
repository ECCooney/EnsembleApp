import 'package:ensemble/core/common/error_text.dart';
import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/auth/screens/login_screen.dart';
import 'package:ensemble/router.dart';
import 'package:ensemble/theme/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Ensemble',
        theme: Pallete.lightModeAppTheme,
        routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) {
            if (data != null) {
              getData(ref, data);
              if (userModel != null) {
                return loggedInRoute;
              }
            }
            return loggedOutRoute;
          },
        ),
        routeInformationParser: const RoutemasterParser(),
      ),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}