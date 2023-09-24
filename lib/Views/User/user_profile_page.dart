import 'package:ambulance_dispatch_application/View_Models/User%20Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
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
          child: FutureBuilder(
            future: context.read<UserManager>().getCurrentUserData(
                context.read<Authentication>().currentUser!.email!),
            builder: (context, snapshot) {
              return snapshot.hasData
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
                                        AssetImage('assets/images/logo.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 120,
                                left: 100,
                                child: InkWell(
                                  onTap: () {},
                                  child: CircleAvatar(
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
                                  '${snapshot.data!.names} ${snapshot.data?.surname}'),
                              SizedBox(
                                width: 3,
                              ),
                              CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    snapshot.data!.accountStatus == 'Verified'
                                        ? AppConstants().appGreen
                                        : AppConstants().appRed,
                                child: Center(
                                    child: snapshot.data!.accountStatus ==
                                            'Verified'
                                        ? const Icon(
                                            Icons.check,
                                            size: 8,
                                          )
                                        : SizedBox()),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Status: ${snapshot.data!.accountStatus}'),
                          snapshot.data!.accountStatus == 'Not Verified'
                              ? TextButton(
                                  onPressed: () {},
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
                            title: Text('0${snapshot.data!.cellphoneNumber}'),
                            subtitle: const Text('Mobile Number'),
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Center(
                                child: Icon(Icons.mail),
                              ),
                            ),
                            title: Text(snapshot.data!.emailaddress),
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
                            title: Text(snapshot.data!.gender),
                            subtitle: const Text('Gender'),
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Center(
                                child: Icon(Icons.person_2),
                              ),
                            ),
                            title: Text(snapshot.data!.idNumber),
                            subtitle: const Text('SA ID Number'),
                          ),
                          const Divider(),
                          const Text('Account Status'),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  snapshot.data!.accountStatus == 'Verified'
                                      ? AppConstants().appGreen
                                      : AppConstants().appRed,
                              child: Center(
                                child:
                                    snapshot.data!.accountStatus == 'Verified'
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.close),
                              ),
                            ),
                            title: Text(snapshot.data!.accountStatus),
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
          ),
        ),
      ),
    );
  }
}
