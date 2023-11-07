// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  File? selfie;
  File? idFront;
  File? idBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Apply for Verification'),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(),
                    selfie != null
                        ? Image.file(
                            selfie!,
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                          )
                        : const SizedBox(),
                    ListTile(
                      title: const Text('Face Picture'),
                      subtitle: const Text(
                          'Take a selfie and upload it here, make sure your facial feature are visible'),
                      trailing: TextButton(
                        child: Text(selfie == null ? 'Upload' : 'Re-Upload'),
                        onPressed: () async {
                          XFile? pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1800,
                            maxHeight: 1800,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              selfie = File(pickedFile.path);
                            });
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    idBack != null
                        ? Image.file(
                            idBack!,
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                          )
                        : const SizedBox(),
                    ListTile(
                      title: const Text('ID back'),
                      subtitle: const Text(
                          'Take a picture of the back of your ID document'),
                      trailing: TextButton(
                        child: Text(idBack == null ? 'Upload' : 'Re-Upload'),
                        onPressed: () async {
                          XFile? pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1800,
                            maxHeight: 1800,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              idBack = File(pickedFile.path);
                            });
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    idFront != null
                        ? Image.file(
                            idFront!,
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                          )
                        : const SizedBox(),
                    ListTile(
                      title: const Text('ID Front'),
                      subtitle: const Text(
                          'Take a picture of the front of your ID document'),
                      trailing: TextButton(
                        child: Text(idFront == null ? 'Upload' : 'Re-Upload'),
                        onPressed: () async {
                          XFile? pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1800,
                            maxHeight: 1800,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              idFront = File(pickedFile.path);
                            });
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    AppBlueButton(
                        onPressed: () async {
                          if (selfie != null &&
                              idBack != null &&
                              idFront != null) {
                            final result = await context
                                .read<UserManager>()
                                .applyForVerification(
                                  selfie: selfie!,
                                  idFront: idFront!,
                                  idBack: idBack!,
                                  userID: context
                                      .read<UserAuthentication>()
                                      .currentUser!
                                      .uid,
                                );
                            if (result == 'OK') {
                              Navigator.of(context).pop();
                              locator
                                  .get<NavigationAndDialogService>()
                                  .showSnackBar(
                                    context: context,
                                    message:
                                        'Your application has been sent through.',
                                    title: 'Success',
                                  );
                            } else {
                              locator
                                  .get<NavigationAndDialogService>()
                                  .showErrorSnackBar(
                                    context: context,
                                    message: result,
                                    title: 'Oops',
                                  );
                            }
                          } else {
                            locator
                                .get<NavigationAndDialogService>()
                                .showErrorSnackBar(
                                  context: context,
                                  message:
                                      'All the photos are required for application',
                                  title: 'Required',
                                );
                          }
                        },
                        text: 'Send Application'),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
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
    );
  }
}
