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
          child: Selector<UserManager, User>(
            selector: (context, user) => user.userData!,
            builder: (context, value, child) {
              return value.accountStatus == 'Verified'
                  ? FloatingActionButton(
                      shape: const CircleBorder(),
                      child: Column(
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
                    )
                  : SizedBox();
            },
          ),
        ),
        floatingActionButtonLocation:
            context.read<UserManager>().userData!.accountStatus == 'Verified'
                ? FloatingActionButtonLocation.centerDocked
                : FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: Selector<UserManager, User>(
          selector: (p0, p1) => p1.userData!,
          builder: (context, value, child) {
            return AnimatedBottomNavigationBar(
              inactiveColor: Colors.grey,
              activeColor: AppConstants().appDarkBlue,
              notchSmoothness: value.accountStatus == 'Verified'
                  ? NotchSmoothness.sharpEdge
                  : NotchSmoothness.defaultEdge,
              height: 70,
              onTap: (index) => setState(() => _bottomNavIndex = index),
              icons: const [
                Icons.home_filled,
                Icons.access_time,
                Icons.holiday_village,
                Icons.account_box,
              ],
              activeIndex: _bottomNavIndex,
              gapLocation: value.accountStatus == 'Verified'
                  ? GapLocation.center
                  : GapLocation.none,
              elevation: 50,
            );
          },
        ));
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
                height: userData.accountStatus == 'Verified'
                    ? MediaQuery.of(context).size.height / 4
                    : MediaQuery.of(context).size.height / 6.5,
              ),
              userData.accountStatus == 'Verified'
                  ? Text(
                      'You are one step away!!',
                    )
                  : userData.accountStatus == 'Verified'
                      ? Text(
                          'An Administrator will verify your Account Shortly',
                        )
                      : SizedBox(),
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
