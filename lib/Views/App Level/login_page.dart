// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/User/home_page.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;

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
        child: SingleChildScrollView(
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            suffixIcon: Icons.remove_red_eye_rounded,
                            hideText: true,
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          AppBlueButton(
                            text: 'Sign In',
                            onPressed: () async {
                              if (_loginFormKey.currentState!.validate()) {
                                final user = await context
                                    .read<Authentication>()
                                    .loginUser(
                                      usernameController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                if (user == null) {
                                  print('Verify email first');
                                } else {
                                  await context
                                      .read<UserManager>()
                                      .getCurrentUserData(context
                                          .read<Authentication>()
                                          .currentUser!
                                          .email!);
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
                                "Don’t have an account yet?",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  usernameController.clear();
                                  passwordController.clear();
                                  Navigator.of(context)
                                      .pushNamed(AppRouteManager.registerPage);
                                },
                                child: const Text(
                                  "Sign Up with Us",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
