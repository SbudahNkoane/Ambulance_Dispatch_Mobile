import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
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
                AppTextField(
                  labelText: 'Names',
                  validationText: 'Enter Your Names',
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'Surname',
                  validationText: 'Enter Your Surname',
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'ID Number',
                  validationText: 'Enter Your ID Number',
                  prefixIcon: Icons.edit_document,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'Email Address',
                  validationText: 'Enter Your Email Address',
                  prefixIcon: Icons.mail_outlined,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'Gender',
                  validationText: 'Enter Your Gender',
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'Cell Phone Number',
                  validationText: 'Enter Your CellPhone Number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'Password',
                  validationText: 'Enter Your Password',
                  prefixIcon: Icons.lock_sharp,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                AppTextField(
                  labelText: 'Confirm Password',
                  validationText: 'Your Passwords Don\'t match',
                  prefixIcon: Icons.lock_open,
                  keyboardType: TextInputType.name,
                  controller: nameController,
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
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
            ),
          ),
        ),
      ),
    );
  }
}
