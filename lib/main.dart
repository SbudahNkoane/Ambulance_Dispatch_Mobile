import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';

import 'package:ambulance_dispatch_application/View_Models/Ambulance_Management/ambulance_management.dart';

import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';

import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  setupLocator();
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
          create: (context) => TicketManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => AmbulanceManager(),
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
