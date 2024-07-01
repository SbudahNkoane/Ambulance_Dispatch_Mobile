// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/Paramedic/paramedic_home_page.dart';
import 'package:ambulance_dispatch_application/Views/User/user_home_page.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/foundation.dart';
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
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
                        style: GoogleFonts.concertOne(fontSize: 40),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
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
                            const SizedBox(
                              height: 10,
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
                            const SizedBox(
                              height: 10,
                            ),
                            AppBlueButton(
                              text: 'Sign In',
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (usernameController.text
                                      .contains('@para.com')) {
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showErrorSnackBar(
                                            context: context,
                                            message:
                                                'You cannot sign in as a normal user with this account.Sign in as Paramedic',
                                            title: 'Account Type');
                                  } else {
                                    final result = await context
                                        .read<UserAuthentication>()
                                        .loginUser(
                                          usernameController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                    if (result != 'OK') {
                                      return locator
                                          .get<NavigationAndDialogService>()
                                          .showErrorSnackBar(
                                            context: context,
                                            message: result,
                                            title: 'Oops',
                                          );
                                    }
                                    if (context
                                            .read<UserAuthentication>()
                                            .currentUser ==
                                        null) {
                                      if (kDebugMode) {
                                        print('Verify email first');
                                      }
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
                                }
                              },
                            ),
                            AppBlueButton(
                              text: 'Sign In as Paramedic',
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (usernameController.text
                                      .contains('@para.com')) {
                                    final result = await context
                                        .read<UserAuthentication>()
                                        .loginUser(
                                          usernameController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                    if (result != 'OK') {
                                      locator
                                          .get<NavigationAndDialogService>()
                                          .showErrorSnackBar(
                                            context: context,
                                            message: result,
                                            title: 'Oops',
                                          );
                                    }
                                    if (context
                                            .read<UserAuthentication>()
                                            .currentUser ==
                                        null) {
                                      if (kDebugMode) {
                                        print('Verify email first');
                                      }
                                    } else {
                                      await context
                                          .read<ParamedicManager>()
                                          .getCurrentParamedicData(context
                                              .read<UserAuthentication>()
                                              .currentUser!
                                              .uid);

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                const ParamedicHomePage(),
                                          ),
                                          (route) => false);
                                    }
                                  } else {
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showErrorSnackBar(
                                            context: context,
                                            message:
                                                'You cannot sign in as a Paramedic with this account.Sign in',
                                            title: 'Account Type');
                                  }
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account yet?",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 20,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    usernameController.clear();
                                    passwordController.clear();

                                    Navigator.of(context).pushNamed(
                                        AppRouteManager.registerPage);
                                  },
                                  child: Text(
                                    "Sign Up with Us",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                30,
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
      ),
    );
  }
}
