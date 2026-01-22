import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gauvigyaan/routing/app_routing.dart';
import 'package:gauvigyaan/services/firebase_options.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';
void main() async {
  // usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  checkForUpdate();
  FlutterNativeSplash.remove();

  runApp(const AppRouting());
}

Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((info) {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().then((value) {}).onError(
            (error, stackTrace) => null,
          );
    }
  }).catchError((e) {});
}
