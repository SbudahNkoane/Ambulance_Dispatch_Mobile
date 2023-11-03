import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/login_page.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/password_reset_page.dart';

import 'package:ambulance_dispatch_application/Views/App_Level/register_page.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/splash_page.dart';
import 'package:ambulance_dispatch_application/Views/Paramedic/paramedic_home_page.dart';
import 'package:ambulance_dispatch_application/Views/Paramedic/ticket_dispatch_page.dart';

import 'package:ambulance_dispatch_application/Views/User/map.dart';
import 'package:ambulance_dispatch_application/Views/User/user_ambulance_track_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_menu_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_home_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_profile_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_request_form_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_ticket_tracking_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_ticket_view_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_tickets_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_account_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  static const String userMenuPage = '/UserMenuPage';
  static const String userMapPage = '/UserMapPage';
  static const String userTicketTrackingPage = '/UserTicketTrackingPage';
  static const String userTicketViewPage = '/UserTicketViewPage';
  static const String userAmbulanceTrackingPage = '/UserAmbulanceTrackingPage';

//========================== Admin Screens =================================================
  static const String adminHomePage = '/AdminHomePage';

//========================== Paramedic Screens ===================================
  static const String paramedicHomePage = '/AmbulancePersonnelHomePage';
  static const String paramedicTicketDispatchPage =
      '/paramedicTicketDispatchHomePage';

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
      case userTicketTrackingPage:
        return MaterialPageRoute(
          builder: (context) => UserTicketTrackingPage(
            ticket: context.read<TicketManager>().bookedTicket!,
          ),
        );
      case userTicketViewPage:
        return MaterialPageRoute(
          builder: (context) => const TicketViewPage(),
        );
      case userAmbulanceTrackingPage:
        return MaterialPageRoute(
          builder: (context) => const AmbulanceTrackingPage(),
        );
      case userMapPage:
        return MaterialPageRoute(
          builder: (context) => const MapScreen(),
        );
      case userTicketsPage:
        return MaterialPageRoute(
          builder: (context) => const UserTicketsPage(),
        );
      case userAccountPage:
        return MaterialPageRoute(
          builder: (context) => const UserAccountPage(),
        );
      case userMenuPage:
        return MaterialPageRoute(
          builder: (context) => const UserMenuPage(),
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

      //========================== Paramedic Screens =============================
      case paramedicHomePage:
        return MaterialPageRoute(
          builder: (context) => const ParamedicHomePage(),
        );
      case paramedicTicketDispatchPage:
        return MaterialPageRoute(
          builder: (context) => const TicketDispatchPage(),
        );
      default:
        throw const FormatException('This Page does not exist!!');
    }
  }
}
