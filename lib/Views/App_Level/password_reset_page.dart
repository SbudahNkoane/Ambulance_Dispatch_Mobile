import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
      body: Stack(
        children: [
          Center(
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
                              hasIconButton: false,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppBlueButton(
                              text: 'Reset Password',
                              onPressed: () async {
                                if (_resetPasswordFormKey.currentState!
                                    .validate()) {
                                  final result = await context
                                      .read<UserAuthentication>()
                                      .resetPassword(
                                          emailController.text.trim());

                                  if (result == 'OK') {
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .goBack();
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showSnackBar(
                                            message: 'Check your email',
                                            title: 'Password reset link Sent!');
                                  } else {
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showErrorSnackBar(
                                            message: result, title: 'Oops!!!');
                                  }
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don’t have an account yet?",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).popAndPushNamed(
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
          Selector<UserAuthentication, Tuple2>(
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
    );
  }
}
