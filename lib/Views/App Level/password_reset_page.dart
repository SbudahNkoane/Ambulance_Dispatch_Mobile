import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants().appDarkWhite,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppConstants().appDarkWhite,
        centerTitle: true,
        toolbarHeight: 240,
        title: Column(
          children: [
            Image.asset(
              AppConstants().logoWithWhiteBackground,
              height: 150,
              width: 150,
            ),
            const Text("Reset Password"),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Form(
                    key: _resetPasswordFormKey,
                    child: Column(
                      children: [
                        AppTextField(
                          labelText: 'Email Address',
                          prefixIcon: Icons.mail_lock,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (names) {
                            if (names == null || names.isEmpty) {
                              return 'Enter Your Email Address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppBlueButton(
                          text: 'Reset Password',
                          onPressed: () {
                            if (_resetPasswordFormKey.currentState!
                                .validate()) {
                              // Process data.
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
                                Navigator.of(context).popAndPushNamed(
                                    AppRouteManager.registerPage);
                              },
                              child: const Text(
                                "Sign Up with Us",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
