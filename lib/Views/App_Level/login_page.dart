// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/User/user_home_page.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  bool _hideText = true;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppConstants().appDarkBlue,
        centerTitle: true,
        toolbarHeight: 230,
        title: Image.asset(
          AppConstants().logoWithBlueBackground,
          height: 170,
          width: 170,
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                // color: Colors.blue,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
                        style: GoogleFonts.moul(fontSize: 40),
                        // TextStyle(
                        //     letterSpacing: 1,
                        //     fontSize: 40,
                        //     fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            AppTextField(
                              controller: usernameController,
                              labelText: 'Username',
                              prefixIcon: Icons.mail,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (usernameController.text.trim().isEmpty) {
                                  return 'Enter your Username';
                                }
                                return null;
                              },
                              hasIconButton: false,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppTextField(
                              onIconPressed: () {
                                setState(() {
                                  _hideText = !_hideText;
                                });
                              },
                              suffixIcon: _hideText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              hideText: _hideText,
                              controller: passwordController,
                              labelText: 'Password',
                              prefixIcon: Icons.password,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (passwordController.text.trim().isEmpty) {
                                  return 'Enter your Password';
                                }
                                return null;
                              },
                              hasIconButton: true,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AppRouteManager.passwordResetPage);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: AppConstants().appRed,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            AppBlueButton(
                              text: 'Sign In',
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  final result = await context
                                      .read<UserAuthentication>()
                                      .loginUser(
                                        usernameController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                  if (result != 'OK') {
                                    return locator
                                        .get<NavigationAndDialogService>()
                                        .showSnackBar(
                                          context: context,
                                          message: result,
                                          title: 'Oops',
                                        );
                                  }
                                  if (context
                                          .read<UserAuthentication>()
                                          .currentUser ==
                                      null) {
                                    print('Verify email first');
                                  } else {
                                    await context
                                        .read<UserManager>()
                                        .getCurrentUserData(context
                                            .read<UserAuthentication>()
                                            .currentUser!
                                            .uid);

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const UserHomePage(),
                                        ),
                                        (route) => false);
                                  }
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account yet?",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    usernameController.clear();
                                    passwordController.clear();

                                    Navigator.of(context).pushNamed(
                                        AppRouteManager.registerPage);
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showSnackBar(
                                          context: context,
                                          message: 'Registration',
                                          title: 'You are rgistered',
                                        );
                                  },
                                  child: const Text(
                                    "Sign Up with Us",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Selector<UserAuthentication, Tuple2>(
              selector: (context, value) =>
                  Tuple2(value.showProgress, value.userProgressText),
              builder: (context, value, child) {
                return value.item1
                    ? AppProgressIndicator(text: "${value.item2}")
                    : Container();
              },
            ),
            Selector<UserManager, Tuple2>(
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
      ),
    );
  }
}
