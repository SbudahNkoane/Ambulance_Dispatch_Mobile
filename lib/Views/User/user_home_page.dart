import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/User/user_account_view.dart';
import 'package:ambulance_dispatch_application/Views/User/user_menu_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_tickets_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavIndex = 0;
  final List<Widget> _pages = [
    const Home(), //0
    const UserTicketsPage(), //1
    const UserTicketsPage(), //2
    const UserAccountView(), //3
    const UserMenuPage(), //4
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              foregroundImage: AssetImage('assets/images/logo.png'),
              backgroundColor: Colors.transparent,
              radius: 25,
            ),
          ),
        ],
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(_bottomNavIndex == 0
            ? 'Home'
            : _bottomNavIndex == 1
                ? 'Tickets'
                : _bottomNavIndex == 4
                    ? 'Menu'
                    : 'Account'),
      ),
      body: Stack(
        children: [
          Center(
            child: _pages[_bottomNavIndex],
          ),
          Selector<TicketManager, Tuple2>(
            selector: (context, value) =>
                Tuple2(value.showProgress, value.userProgressText),
            builder: (context, value, child) {
              return value.item1
                  ? AppProgressIndicator(text: "${value.item2}")
                  : Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder(
        stream: context.read<UserManager>().userStreamer(),
        builder: (context, snapshot) {
          return Selector<UserManager, User>(
            selector: (p0, p1) => p1.userData!,
            builder: (context, value, child) {
              return BottomNavigationBar(
                selectedItemColor: Color.fromARGB(255, 54, 128, 247),
                onTap: (index) async {
                  if (index == 2) {
                    if (context.read<UserManager>().userData!.accountStatus !=
                        'Verified') {
                      await Navigator.of(context)
                          .pushNamed(AppRouteManager.userAccountPage);
                      _bottomNavIndex = 0;
                    } else {
                      Navigator.of(context)
                          .pushNamed(AppRouteManager.userRequestFormPage);
                      _bottomNavIndex = 1;
                    }
                  } else if (index == 1) {
                    if (context.read<TicketManager>().userTickets.isEmpty) {
                      await context.read<TicketManager>().getTickets(
                          context.read<UserAuthentication>().currentUser!.uid);
                    }

                    _bottomNavIndex = 1;
                  } else {
                    _bottomNavIndex = index;
                  }

                  setState(() {});
                },
                unselectedItemColor: Color.fromARGB(255, 109, 109, 109),
                type: BottomNavigationBarType.fixed,
                currentIndex: _bottomNavIndex,
                items: List.from([
                  const BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home_filled),
                  ),
                  const BottomNavigationBarItem(
                      label: 'Tickets', icon: Icon(Icons.home_filled)),
                  context.read<UserManager>().userData!.accountStatus ==
                          "Verified"
                      ? BottomNavigationBarItem(
                          label: '',
                          icon: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.carOn,
                                  size: 40,
                                  color: Color.fromARGB(255, 54, 128, 247),
                                ),
                                Text(
                                  'Request',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                          ))
                      : const BottomNavigationBarItem(
                          label: 'Apply',
                          icon: Icon(Icons.verified_user),
                        ),
                  const BottomNavigationBarItem(
                      label: 'Account',
                      icon: Icon(
                        Icons.account_box,
                      )),
                  const BottomNavigationBarItem(
                      label: 'Menu',
                      icon: Icon(
                        Icons.menu,
                      )),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<UserManager>().userStreamer(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Selector<UserManager, User>(
            selector: (context, user) => user.userData!,
            builder: (context, userData, child) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hello ${userData.names}',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: userData.accountStatus == 'Not Verified'
                        ? MediaQuery.of(context).size.height / 5.6
                        : MediaQuery.of(context).size.height / 6.5,
                  ),
                  userData.accountStatus == 'Not Verified'
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'You are one step away!!\nMake sure to apply for verification by clicking the Apply button.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      : Text(
                          'Welcome',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Image.asset(
                    'assets/images/med.png',
                    height: MediaQuery.of(context).size.height / 2.8,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
