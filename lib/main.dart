import 'dart:developer';

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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/providers/firebase_providers.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCMToken $fcmToken");
  await FirebaseAppCheck.instance.activate(
    // // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // // argument for `webProvider`
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // // your preferred provider. Choose from:
    // // 1. Debug provider
    // // 2. Safety Net provider
    // // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // // your preferred provider. Choose from:
    // // 1. Debug provider
    // // 2. Device Check provider
    // // 3. App Attest provider
    // // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    // appleProvider: AppleProvider.appAttest,
  );
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
    // FlutterNativeSplash.remove();
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