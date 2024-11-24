// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Models/paramedic.dart';
import 'package:ambulance_dispatch_application/View_Models/Ambulance_Management/ambulance_management.dart';
import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/login_page.dart';
import 'package:ambulance_dispatch_application/Views/Paramedic/ambulance_assign_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ParamedicHomePage extends StatefulWidget {
  const ParamedicHomePage({super.key});

  @override
  State<ParamedicHomePage> createState() => _ParamedicHomePageState();
}

class _ParamedicHomePageState extends State<ParamedicHomePage> {
  int _bottomNavIndex = 0;
  final List<Widget> _pages = [
    const ParamedicHome(), //0
    const AssignAmbulancePage(), //1
  ];

  @override
  void initState() {
    // context.read<ParamedicManager>().getUserLocation();
    super.initState();
  }

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
                ? 'Dispatch'
                : 'Menu'),
      ),
      body: Stack(
        children: [
          Center(
            child: _pages[_bottomNavIndex],
          ),
          Selector<ParamedicManager, Tuple2>(
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
        stream: context.read<ParamedicManager>().userStreamer(),
        builder: (context, snapshot) {
          return Selector<ParamedicManager, Paramedic>(
            selector: (p0, p1) => p1.paramedicData!,
            builder: (context, value, child) {
              return BottomNavigationBar(
                selectedItemColor: const Color.fromARGB(255, 54, 128, 247),
                onTap: (index) async {
                  if (index == 1) {
                    await context
                        .read<ParamedicManager>()
                        .getParamedicLocation();
                    await context
                        .read<AmbulanceManager>()
                        .getAvailableAmbulances();
                    _bottomNavIndex = 1;
                  } else if (index == 2) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 30,
                          child: AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 247, 248, 249),
                            shape: const RoundedRectangleBorder(),
                            title: const Text('Log Out'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Are you sure want to logout??'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () async {
                                  final result = await context
                                      .read<UserAuthentication>()
                                      .logoutUser();
                                  if (result == 'OK') {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const LoginScreen(),
                                        ),
                                        (route) => false);
                                  } else {}
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    _bottomNavIndex = index;
                  }

                  setState(() {});
                },
                unselectedItemColor: const Color.fromARGB(255, 109, 109, 109),
                type: BottomNavigationBarType.fixed,
                currentIndex: _bottomNavIndex,
                items: List.from([
                  const BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home_filled),
                  ),
                  BottomNavigationBarItem(
                      label: '',
                      icon: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: const Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.carOn,
                              size: 40,
                              color: Color.fromARGB(255, 54, 128, 247),
                            ),
                            Text(
                              'Dispatch',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                      )),
                  const BottomNavigationBarItem(
                      label: 'Logout',
                      icon: Icon(
                        Icons.logout,
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

class ParamedicHome extends StatefulWidget {
  const ParamedicHome({super.key});

  @override
  State<ParamedicHome> createState() => _ParamedicHomeState();
}

class _ParamedicHomeState extends State<ParamedicHome> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<ParamedicManager>().userStreamer(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Selector<ParamedicManager, Paramedic>(
            selector: (context, user) => user.paramedicData!,
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
                    height: MediaQuery.of(context).size.height / 6.5,
                  ),
                  // userData.accountStatus == 'Not Verified'
                  //     ? Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         child: Text(
                  //           'You are one step away!!\nMake sure to apply for verification by clicking the Apply button.',
                  //           textAlign: TextAlign.center,
                  //           style: GoogleFonts.inter(
                  //               fontWeight: FontWeight.bold, fontSize: 18),
                  //         ),
                  //       )
                  Text(
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
