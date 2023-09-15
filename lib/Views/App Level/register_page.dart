import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController genderController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  @override
  void initState() {
    namesController = TextEditingController();
    surnameController = TextEditingController();
    idNumberController = TextEditingController();
    emailController = TextEditingController();
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
            Text("Sign Up"),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        AppTextField(
                          labelText: 'Names',
                          validationText: 'Enter Your Names',
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.name,
                          controller: namesController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Surname',
                          validationText: 'Enter Your Surname',
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.name,
                          controller: surnameController,
                          validator: (usernameController) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'ID Number',
                          validationText: 'Enter Your ID Number',
                          prefixIcon: Icons.edit_document,
                          keyboardType: TextInputType.name,
                          controller: idNumberController,
                          validator: (usernameController) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Email Address',
                          validationText: 'Enter Your Email Address',
                          prefixIcon: Icons.mail_outlined,
                          keyboardType: TextInputType.name,
                          controller: emailController,
                          validator: (usernameController) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Gender',
                          validationText: 'Enter Your Gender',
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.name,
                          controller: genderController,
                          validator: (usernameController) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Cell Phone Number',
                          validationText: 'Enter Your CellPhone Number',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.name,
                          controller: phoneNumberController,
                          validator: (usernameController) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Password',
                          validationText: 'Enter Your Password',
                          prefixIcon: Icons.lock_sharp,
                          keyboardType: TextInputType.name,
                          controller: passwordController,
                          validator: (usernameController) {
                            return null;
                          },
                        ),
                        AppTextField(
                          labelText: 'Confirm Password',
                          validationText: 'Your Passwords Don\'t match',
                          prefixIcon: Icons.lock_open,
                          keyboardType: TextInputType.name,
                          controller: confirmPasswordController,
                          validator: (usernameController) {
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
                        AppBlueButton(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 110,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
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
