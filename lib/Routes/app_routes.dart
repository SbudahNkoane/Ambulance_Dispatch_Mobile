import 'package:ambulance_dispatch_application/Views/App%20Level/login_page.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/password_reset_page.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/register_page.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/splash_page.dart';
import 'package:ambulance_dispatch_application/Views/User/account_page.dart';
import 'package:ambulance_dispatch_application/Views/User/home_page.dart';
import 'package:ambulance_dispatch_application/Views/User/profile_page.dart';
import 'package:ambulance_dispatch_application/Views/User/request_form_page.dart';
import 'package:ambulance_dispatch_application/Views/User/tickets_page.dart';
import 'package:flutter/material.dart';

class AppRouteManager {
  // ===========================App Level Screens==================================================
  static const String splashPage = '/';
  static const String loginPage = '/Login';
  static const String registerPage = '/Register';
  static const String passwordResetPage = '/ResetPassword';

// ========================== User Screens =================================================
  static const String userHomePage = '/UserHomePage';
  static const String userTicketsPage = '/UserTicketsPage';
  static const String userAccountPage = '/UserAccountPage';
  static const String userRequestFormPage = '/UserRequestFormPage';
  static const String userProfilePage = '/UserProfilePage';

//========================== Admin Screens =================================================
  static const String adminHomePage = '/AdminHomePage';

//========================== Ambulance Personnel Screens ===================================
  static const String ambulancePersonnelHomePage =
      '/AmbulancePersonnelHomePage';

  AppRouteManager._();

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
      //========================== User Screens ===========================================
      case userHomePage:
        return MaterialPageRoute(
          builder: (context) => const UserHomePage(),
        );
      case userTicketsPage:
        return MaterialPageRoute(
          builder: (context) => const UserTicketsPage(),
        );
      case userAccountPage:
        return MaterialPageRoute(
          builder: (context) => const UserAccountPage(),
        );
      case userRequestFormPage:
        return MaterialPageRoute(
          builder: (context) => const UserRequestFromPage(),
        );
      case userProfilePage:
        return MaterialPageRoute(
          builder: (context) => const UserProfilePage(),
        );
      //========================== Admin Screens ===========================================

      //========================== Ambulance Personnel Screens =============================

      default:
        throw const FormatException('This Page does not exist!!');
    }
  }
}
