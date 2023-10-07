// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/View_Models/User%20Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: context.read<UserManager>().userStream,
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: context.read<UserManager>().getCurrentUserData(
                      context.read<UserAuthentication>().currentUser!.uid),
                  builder: (context, info) {
                    return info.hasData
                        ? Padding(
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
                                        CircleAvatar(
                                          radius: 80,
                                          foregroundImage:
                                              info.data!.profilePicture == null
                                                  ? Image.network(info.data!
                                                          .profilePicture!)
                                                      as ImageProvider<Object>
                                                  : const AssetImage(
                                                      'assets/images/logo.png'),
                                          // ? NetworkImage(
                                          //     info.data!.profilePicture!)
                                          // : const AssetImage(
                                          //         'assets/images/logo.png')
                                          //     as ImageProvider,
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
                                                return Container(
                                                  child: Wrap(
                                                    children: <Widget>[
                                                      ListTile(
                                                          leading: Icon(Icons
                                                              .photo_size_select_actual_rounded),
                                                          title:
                                                              Text('Gallery'),
                                                          onTap: () => {
                                                                source =
                                                                    ImageSource
                                                                        .gallery,
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                              }),
                                                      ListTile(
                                                        leading:
                                                            Icon(Icons.camera),
                                                        title: Text('Camera'),
                                                        onTap: () => {
                                                          source = ImageSource
                                                              .camera,
                                                          Navigator.of(context)
                                                              .pop(),
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading:
                                                            Icon(Icons.block),
                                                        title: Text('Remove'),
                                                        onTap: () => {
                                                          remove = true,
                                                          Navigator.of(context)
                                                              .pop(),
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                          source != null || remove == true
                                              ? context
                                                  .read<UserManager>()
                                                  .updateProfilePicture(
                                                    source: source!,
                                                    userID: info.data!.userID!,
                                                    remove: remove,
                                                  )
                                              : SizedBox();
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
                                    Text(
                                        '${info.data!.names} ${info.data?.surname}'),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    CircleAvatar(
                                      radius: 7,
                                      backgroundColor:
                                          info.data!.accountStatus == 'Verified'
                                              ? AppConstants().appGreen
                                              : AppConstants().appRed,
                                      child: Center(
                                          child: info.data!.accountStatus ==
                                                  'Verified'
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
                                Text('Status: ${info.data!.accountStatus}'),
                                info.data!.accountStatus == 'Not Verified'
                                    ? TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                            'Apply for Verification'),
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
                                  title: Text('0${info.data!.cellphoneNumber}'),
                                  subtitle: const Text('Mobile Number'),
                                ),
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: Center(
                                      child: Icon(Icons.mail),
                                    ),
                                  ),
                                  title: Text(info.data!.emailaddress),
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
                                  title: Text(info.data!.gender),
                                  subtitle: const Text('Gender'),
                                ),
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: Center(
                                      child: Icon(Icons.person_2),
                                    ),
                                  ),
                                  title: Text(info.data!.idNumber),
                                  subtitle: const Text('SA ID Number'),
                                ),
                                const Divider(),
                                const Text('Account Status'),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        info.data!.accountStatus == 'Verified'
                                            ? AppConstants().appGreen
                                            : AppConstants().appRed,
                                    child: Center(
                                      child:
                                          info.data!.accountStatus == 'Verified'
                                              ? const Icon(Icons.check)
                                              : const Icon(Icons.close),
                                    ),
                                  ),
                                  title: Text(info.data!.accountStatus),
                                  subtitle: const Text('You are good to go!!'),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                );
              }),
        ),
      ),
    );
  }
}
