// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:ambulance_dispatch_application/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitApp {
  static initializeApp(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (context.mounted == true) {
        if (user == null) {
          Navigator.of(context).popAndPushNamed(AppRouteManager.loginPage);
        } else {
          context.read<UserAuthentication>().setCurrentUser(user);
          if (user.email!.endsWith('para.com')) {
            await context.read<ParamedicManager>().getCurrentParamedicData(
                context.read<UserAuthentication>().currentUser!.uid);

            Navigator.of(context)
                .popAndPushNamed(AppRouteManager.paramedicHomePage);
          } else {
            await context.read<UserManager>().getCurrentUserData(
                context.read<UserAuthentication>().currentUser!.uid);
            Navigator.of(context).popAndPushNamed(AppRouteManager.userHomePage);
          }
        }
      }
    });
  }
}
