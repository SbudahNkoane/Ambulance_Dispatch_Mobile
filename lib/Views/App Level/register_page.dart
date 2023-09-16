// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  @override
  void initState() {
    namesController = TextEditingController();
    surnameController = TextEditingController();
    idNumberController = TextEditingController();
    emailController = TextEditingController();
    confirmEmailController = TextEditingController();
    genderController = TextEditingController();
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
            const Text("Sign Up"),
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
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        AppTextField(
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
                          labelText: 'Confirm Email Address',
                          prefixIcon: Icons.mail_outlined,
                          keyboardType: TextInputType.emailAddress,
                          controller: confirmEmailController,
                          validator: (emailConfirm) {
                            if (emailConfirm == null || emailConfirm.isEmpty) {
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
                            });
                          },
                        ),
                        AppTextField(
                          labelText: 'Cell Phone Number',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          controller: phoneNumberController,
                          validator: (phoneNumber) {
                            if (phoneNumber == null || phoneNumber.isEmpty) {
                              return 'Enter your Phone Number';
                            } else if (phoneNumber.trim().length != 10) {
                              return 'Please enter a Valid Phone Number';
                            }
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Password',
                          prefixIcon: Icons.lock_sharp,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'Enter your password';
                            }
                            // else if (password.trim() !=
                            //     emailController.text.trim()) {
                            //   return 'Your Emails Don\'t match';
                            // }
                            return null;
                          },
                        ),
                        AppTextField(
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
                        // AppTextField(
                        //   labelText: 'Name',
                        //   validationText: 'Enter Your Name',
                        //   prefixIcon: Icons.person,
                        //   keyboardType: TextInputType.name,
                        //   controller: nameController,
                        // ),
                        // AppTextField(
                        //   labelText: 'Name',
                        //   validationText: 'Enter Your Name',
                        //   prefixIcon: Icons.person,
                        //   keyboardType: TextInputType.name,
                        //   controller: nameController,
                        // ),
                        // AppTextField(
                        //   labelText: 'Name',
                        //   validationText: 'Enter Your Name',
                        //   prefixIcon: Icons.person,
                        //   keyboardType: TextInputType.name,
                        //   controller: nameController,
                        // ),
                        AppBlueButton(
                          text: 'Sign Up',
                          onPressed: () async {
                            User user = User(
                              names: namesController.text.trim(),
                              surname: surnameController.text.trim(),
                              idNumber: idNumberController.text.trim(),
                              emailaddress: emailController.text.trim(),
                              gender: genderController.text.trim(),
                              cellphoneNumber:
                                  phoneNumberController.text.trim(),
                            );

                            if (_registerFormKey.currentState!.validate()) {
                              await context
                                  .read<Authentication>()
                                  .registerNewUser(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    user,
                                  );
                              Navigator.of(context).pop();
                              //  if(context
                              //       .read<Authentication>()
                              //       .currentUser!.emailVerified){

                              //  }Navigator.of(context).pushAndRemoveUntil(
                              //       MaterialPageRoute<void>(
                              //           builder: (BuildContext context) =>
                              //               const UserHomePage()),
                              //       (route) => false);
                            }
                          },
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 110,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
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
