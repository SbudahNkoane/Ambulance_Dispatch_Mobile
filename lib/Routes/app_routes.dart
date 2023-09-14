import 'package:ambulance_dispatch_application/Views/App%20Level/login_page.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/password_reset_page.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/register_page.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/splash_page.dart';
import 'package:flutter/material.dart';

class AppLevelRouteManager {
  // ===========================App Level Screens==================================================
  static const String splashPage = '/';
  static const String loginPage = '/Login';
  static const String registerPage = '/Register';
  static const String passwordResetPage = '/ResetPassword';

// ========================== User Screens =================================================
  static const String userHomePage = '/UserHomePage';

//========================== Admin Screens =================================================
  static const String adminHomePage = '/AdminHomePage';

//========================== Ambulance Personnel Screens ===================================
  static const String ambulancePersonnelHomePage =
      '/AmbulancePersonnelHomePage';

  AppLevelRouteManager._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ========================== App Level Screens ======================================
      case splashPage:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );
      case passwordResetPage:
        return MaterialPageRoute(
          builder: (context) => const PasswordResetScreen(),
        );
      //========================== Admin Screens ===========================================

      //========================== Ambulance Personnel Screens =============================

      default:
        throw const FormatException('This Page does not exist!!');
    }
  }
}
