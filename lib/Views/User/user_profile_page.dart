// ignore_for_file: use_build_context_synchronously
import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Selector<UserManager, User>(
                selector: (p0, p1) => p1.userData!,
                builder: (context, info, child) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      right: 10,
                      left: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                info.profilePicture != null
                                    ? CircleAvatar(
                                        radius: 80,
                                        foregroundImage:
                                            NetworkImage(info.profilePicture!),
                                      )
                                    : CircleAvatar(
                                        radius: 80,
                                        foregroundImage: info.gender == 'Male'
                                            ? const AssetImage(
                                                'assets/images/profileMale.png')
                                            : const AssetImage(
                                                'assets/images/profileFemale.png'),
                                        backgroundColor: Colors.transparent,
                                      ),
                              ],
                            ),
                            Positioned(
                              top: 120,
                              left: 100,
                              child: InkWell(
                                onTap: () async {
                                  ImageSource? source;
                                  bool remove = false;
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Wrap(
                                          children: <Widget>[
                                            ListTile(
                                                leading: const Icon(Icons
                                                    .photo_size_select_actual_rounded),
                                                title: const Text('Gallery'),
                                                onTap: () => {
                                                      source =
                                                          ImageSource.gallery,
                                                      Navigator.of(context)
                                                          .pop(),
                                                    }),
                                            ListTile(
                                              leading: const Icon(Icons.camera),
                                              title: const Text('Camera'),
                                              onTap: () => {
                                                source = ImageSource.camera,
                                                Navigator.of(context).pop(),
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.block),
                                              title: const Text('Remove'),
                                              onTap: () => {
                                                source = null,
                                                remove = true,
                                                Navigator.of(context).pop(),
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                  source != null || remove == true
                                      ? context
                                          .read<UserManager>()
                                          .updateProfilePicture(
                                            source: source,
                                            userID: info.userID!,
                                            remove: remove,
                                          )
                                      : const SizedBox();
                                },
                                child: const CircleAvatar(
                                  child: Center(
                                    child: Icon(Icons.camera_enhance),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('${info.names} ${info.surname}'),
                            const SizedBox(
                              width: 3,
                            ),
                            CircleAvatar(
                              radius: 7,
                              backgroundColor: info.accountStatus == 'Verified'
                                  ? AppConstants().appGreen
                                  : AppConstants().appRed,
                              child: Center(
                                  child: info.accountStatus == 'Verified'
                                      ? const Icon(
                                          Icons.check,
                                          size: 8,
                                        )
                                      : const SizedBox()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Status: ${info.accountStatus}'),
                        info.accountStatus == 'Not Verified'
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      AppRouteManager.userAccountPage);
                                },
                                child: const Text('Apply for Verification'),
                              )
                            : const SizedBox(),
                        const Text('About'),
                        const Divider(),
                        const Text('Contact info'),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Center(
                              child: Icon(Icons.phone),
                            ),
                          ),
                          title: Text(info.cellphoneNumber),
                          subtitle: const Text('Mobile Number'),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Center(
                              child: Icon(Icons.mail),
                            ),
                          ),
                          title: Text(info.emailaddress),
                          subtitle: const Text('Email'),
                        ),
                        const Divider(),
                        const Text('Basic info'),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Center(
                              child: Icon(Icons.person_2),
                            ),
                          ),
                          title: Text(info.gender),
                          subtitle: const Text('Gender'),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Center(
                              child: Icon(Icons.person_2),
                            ),
                          ),
                          title: Text(info.idNumber),
                          subtitle: const Text('SA ID Number'),
                        ),
                        const Divider(),
                        const Text('Account Status'),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: info.accountStatus == 'Verified'
                                ? AppConstants().appGreen
                                : AppConstants().appRed,
                            child: Center(
                              child: info.accountStatus == 'Verified'
                                  ? const Icon(Icons.check)
                                  : const Icon(Icons.close),
                            ),
                          ),
                          title: Text(info.accountStatus),
                          subtitle: Text(info.accountStatus == 'Verified'
                              ? 'You are good to go!!'
                              : 'Make sure you are verified'),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  );
                },
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
      ),
    );
  }
}
