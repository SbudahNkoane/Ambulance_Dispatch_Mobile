import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InitApp {
  static initializeApp(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBONKBvXus1aY3ZycS-E3Qhl0n9yjgA4pc",
            appId: "1:465560543092:web:007f4ee3e335cf26c15621",
            messagingSenderId: "465560543092",
            projectId: "ambulance-dispatch-syste-c3397"),
      );
    } else {
      await Firebase.initializeApp();
    }

    Navigator.of(context).popAndPushNamed(AppLevelRouteManager.loginPage);
  }
}
