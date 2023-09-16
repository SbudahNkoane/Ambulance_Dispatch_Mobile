import 'package:ambulance_dispatch_application/initialize_app.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          seconds: 3,
        ),
        delay);
  }

  void delay() {
    InitApp.initializeApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 80,
          foregroundImage: AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }
}
