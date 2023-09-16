import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/User/account_page.dart';
import 'package:ambulance_dispatch_application/Views/User/tickets_page.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _bottomNavIndex = 0;
  final List<Widget> _pages = [
    const Home(),
    const UserTicketsPage(),
    const UserTicketsPage(),
    const UserAccountPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                : _bottomNavIndex == 3
                    ? 'Account'
                    : 'Menu'),
      ),
      body: Center(
        child: _pages[_bottomNavIndex],
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.card_travel,
                size: 13,
              ),
              Text(
                "Request",
                style: TextStyle(
                  fontSize: 10,
                ),
              )
            ],
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AppRouteManager.userRequestFormPage);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor: Colors.grey,
        activeColor: AppConstants().appDarkBlue,
        notchSmoothness: NotchSmoothness.sharpEdge,
        height: 70,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        icons: const [
          Icons.home_filled,
          Icons.access_time,
          Icons.holiday_village,
          Icons.account_box,
        ],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        elevation: 50,
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Selector<UserManager, User>(
        selector: (context, user) => user.userData!,
        builder: (context, userData, child) {
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
                height: MediaQuery.of(context).size.height / 4,
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
  }
}
