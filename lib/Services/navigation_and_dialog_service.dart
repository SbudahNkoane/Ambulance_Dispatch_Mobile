import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationAndDialogService {
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  } //navigateTo

  Future<dynamic> popAllandNavigateTo(String routeName) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> popAndNavigateTo(String routeName) {
    return navigatorKey.currentState!.popAndPushNamed(routeName);
  } //popAndNavigateTo

  void goBack() {
    return navigatorKey.currentState!.pop();
  } //goBack

  void showSnackBar1(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 2500),
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      )),
      backgroundColor: Color.fromARGB(255, 89, 125, 245),
      content: ListTile(
        title: Text('data'),
        subtitle: Text(message),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBar(
      {BuildContext? context, required String message, required String title}) {
    Flushbar(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: const Color.fromARGB(255, 167, 218, 248),
      title: title,
      message: message,
      titleColor: const Color.fromARGB(255, 102, 102, 102),
      messageColor: const Color.fromARGB(255, 102, 102, 102),
      duration: const Duration(milliseconds: 3400),
      flushbarPosition: FlushbarPosition.BOTTOM,
      maxWidth: double.infinity,
      margin: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
    ).show(context!);
  }

  void showErrorSnackBar({required String message, required String title}) {
    Flushbar(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: const Color.fromARGB(255, 167, 218, 248),
      title: title,
      message: message,
      titleColor: const Color.fromARGB(255, 254, 2, 2),
      messageColor: const Color.fromARGB(255, 250, 3, 3),
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.BOTTOM,
      maxWidth: double.infinity,
      margin: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
    ).show(navigatorKey.currentState!.context);
  }

  Future showPopupDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.only(bottom: 50, left: 40, right: 50, top: 30),
            title: Row(
              children: [
                const Text(
                  'Register as:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: const Color.fromARGB(255, 167, 218, 248),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory),
                        onPressed: () {
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            const Text(
                              'Student',
                              style: TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                            const SizedBox(width: 80),
                            Icon(
                              Icons.check_circle_outline,
                              color: const Color.fromARGB(255, 102, 102, 102),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 167, 218, 248),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory),
                        onPressed: () {
                          setState(
                            () {},
                          );
                        },
                        child: Row(
                          children: [
                            const Text(
                              'Landlord',
                              style: TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                            const SizedBox(width: 80),
                            Icon(
                              Icons.check_circle_outline,
                              color: const Color.fromARGB(255, 102, 102, 102),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Continue',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
