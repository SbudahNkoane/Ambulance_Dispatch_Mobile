import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/Admin%20Management/admin_management.dart';
import 'package:ambulance_dispatch_application/View_Models/Paramedic%20Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/user_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserAuthentication(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => ParamedicManager(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AmbuQuick',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005DF4)),
          useMaterial3: true,
        ),
        initialRoute: AppRouteManager.splashPage,
        onGenerateRoute: AppRouteManager.generateRoute,
      ),
    );
  }
}
