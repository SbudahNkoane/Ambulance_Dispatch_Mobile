// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late TextEditingController namesController;
  late TextEditingController surnameController;
  late TextEditingController idNumberController;
  late TextEditingController emailController;
  late TextEditingController confirmEmailController;
  late TextEditingController genderController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  String dropdownValue = 'Male';
  bool _hideText = true;
  @override
  void initState() {
    namesController = TextEditingController();
    surnameController = TextEditingController();
    idNumberController = TextEditingController();
    emailController = TextEditingController();
    confirmEmailController = TextEditingController();
    genderController = TextEditingController();
    genderController.text = dropdownValue;
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namesController.dispose();
    surnameController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    confirmEmailController.dispose();
    genderController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            Text(
              "Sign Up",
              style: GoogleFonts.moul(fontSize: 40),
            ),
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
                        key: _registerFormKey,
                        child: Column(
                          children: [
                            AppTextField(
                              hasIconButton: false,
                              labelText: 'Name(s)',
                              prefixIcon: Icons.person,
                              keyboardType: TextInputType.name,
                              controller: namesController,
                              validator: (names) {
                                if (names == null || names.isEmpty) {
                                  return 'Enter Your name(s)';
                                }
                                return null;
                              },
                            ),
                            AppTextField(
                              hasIconButton: false,
                              labelText: 'Surname',
                              prefixIcon: Icons.person,
                              keyboardType: TextInputType.name,
                              controller: surnameController,
                              validator: (surname) {
                                if (surname == null || surname.isEmpty) {
                                  return 'Enter Your Surname';
                                }
                                return null;
                              },
                            ),
                            AppTextField(
                              onChanged: (text) {
                                if (text[6] == '5') {
                                  setState(() {
                                    dropdownValue = 'Male';
                                  });
                                } else if (text[6] == '4') {
                                  setState(() {
                                    dropdownValue = 'Female';
                                  });
                                }
                              },
                              hasIconButton: false,
                              labelText: 'ID Number',
                              prefixIcon: Icons.edit_document,
                              keyboardType: TextInputType.number,
                              controller: idNumberController,
                              validator: (idNumber) {
                                if (idNumber == null || idNumber.isEmpty) {
                                  return 'Enter Your ID Number';
                                } else if (idNumber.length < 13) {
                                  return 'Enter Valid ID Number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppTextField(
                              hasIconButton: false,
                              labelText: 'Email Address',
                              prefixIcon: Icons.mail_outlined,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (email) {
                                if (email == null || email.isEmpty) {
                                  return 'Enter Your Email Address';
                                }
                                return null;
                              },
                            ),
                            AppTextField(
                              hasIconButton: false,
                              labelText: 'Confirm Email Address',
                              prefixIcon: Icons.mail_outlined,
                              keyboardType: TextInputType.emailAddress,
                              controller: confirmEmailController,
                              validator: (emailConfirm) {
                                if (emailConfirm == null ||
                                    emailConfirm.isEmpty) {
                                  return 'Confirm your Email Address';
                                } else if (emailConfirm.trim() !=
                                    emailController.text.trim()) {
                                  return 'Your Emails Don\'t match';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField(
                              alignment: Alignment.centerRight,
                              value: dropdownValue,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              dropdownColor: const Color(0xFFEAEAEA),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 59, 59, 59),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: AppConstants().appDarkBlue,
                                  ),
                                ),
                                fillColor: const Color(0xFFEAEAEA),
                                filled: true,
                              ),
                              items: <String>[
                                'Male',
                                'Female',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  genderController.text = newValue;
                                });
                              },
                            ),
                            AppTextField(
                              hasIconButton: false,
                              labelText: 'Cell Phone Number',
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              controller: phoneNumberController,
                              validator: (phoneNumber) {
                                if (phoneNumber == null ||
                                    phoneNumber.isEmpty) {
                                  return 'Enter your Phone Number';
                                } else if (phoneNumber.trim().length != 10) {
                                  return 'Please enter a Valid Phone Number';
                                }
                                return null;
                              },
                            ),
                            AppTextField(
                              hideText: _hideText,
                              suffixIcon: _hideText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              hasIconButton: true,
                              onIconPressed: () {
                                setState(() {
                                  _hideText = !_hideText;
                                });
                              },
                              labelText: 'Password',
                              prefixIcon: Icons.lock_sharp,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return 'Enter your password';
                                }

                                return null;
                              },
                            ),
                            AppTextField(
                              hideText: _hideText,
                              suffixIcon: _hideText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              onIconPressed: () {
                                setState(() {
                                  _hideText = !_hideText;
                                });
                              },
                              hasIconButton: true,
                              labelText: 'Confirm Password',
                              prefixIcon: Icons.lock_open,
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              validator: (confirmPassword) {
                                if (confirmPassword == null ||
                                    confirmPassword.isEmpty) {
                                  return 'Confirm your Password';
                                } else if (confirmPassword.trim() !=
                                    passwordController.text.trim()) {
                                  return 'Your Passwords Don\'t match';
                                }
                                return null;
                              },
                            ),
                            AppBlueButton(
                              text: 'Sign Up',
                              onPressed: () async {
                                User user = User(
                                  profilePicture: null,
                                  userID: null,
                                  idDocument: {
                                    'ID_Back': null,
                                    'ID_Front': null,
                                  },
                                  verificationPicture: null,
                                  verifiedBy: null,
                                  role: 'User',
                                  names: namesController.text.trim(),
                                  surname: surnameController.text.trim(),
                                  idNumber: idNumberController.text.trim(),
                                  emailaddress: emailController.text.trim(),
                                  gender: genderController.text.trim(),
                                  cellphoneNumber:
                                      phoneNumberController.text.trim(),
                                  accountStatus: 'Not Verified',
                                );

                                if (_registerFormKey.currentState!.validate()) {
                                  final result = await context
                                      .read<UserAuthentication>()
                                      .registerNewUser(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                          user);
                                  if (result == 'OK') {
                                    Navigator.of(context).pop();
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showSnackBar(
                                            context: context,
                                            message:
                                                'You Have been Successfully Registered',
                                            title: 'Registration');
                                  } else {
                                    locator
                                        .get<NavigationAndDialogService>()
                                        .showSnackBar(
                                            context: context,
                                            message: result,
                                            title: 'Oops!');
                                  }
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                        fontSize: 15,
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
