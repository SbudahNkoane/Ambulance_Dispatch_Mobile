import 'dart:math';

import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppTextField(
                            controller: usernameController,
                            labelText: 'Username',
                            validationText: 'Enter your Username',
                            prefixIcon: Icons.mail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            suffixIcon: Icons.remove_red_eye_rounded,
                            hideText: true,
                            controller: passwordController,
                            labelText: 'Password',
                            validationText: 'Enter your Password',
                            prefixIcon: Icons.password,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      AppLevelRouteManager.passwordResetPage);
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
                          AppBlueButton(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t have an account yet?",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  usernameController.clear();
                                  passwordController.clear();
                                  Navigator.of(context).pushNamed(
                                      AppLevelRouteManager.registerPage);
                                },
                                child: Text(
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
