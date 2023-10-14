import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: StreamBuilder(
        stream: context.read<UserManager>().userStreamer(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // if (snapshot.connectionState == ConnectionState.active) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          return Selector<UserManager, User>(
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_2_rounded),
                      trailing: value.accountStatus == "Not Verified" &&
                              value.idDocument!['ID_Back'] != null &&
                              value.idDocument!['ID_Back'] != '' &&
                              value.idDocument!['ID_Front'] != null &&
                              value.idDocument!['ID_Front'] != '' &&
                              value.verificationPicture != null &&
                              value.verificationPicture != ''
                          ? CircularProgressIndicator()
                          : value.accountStatus == "Not Verified" &&
                                      value.idDocument!['ID_Back'] == null ||
                                  value.idDocument!['ID_Back'] == '' &&
                                      value.idDocument!['ID_Front'] == null ||
                                  value.idDocument!['ID_Front'] == '' &&
                                      value.verificationPicture == null ||
                                  value.verificationPicture == ''
                              ? TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        AppRouteManager.userAccountPage);
                                  },
                                  child: Text('Apply'),
                                )
                              : Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                      title: Text(value.accountStatus == "Not Verified" &&
                              value.idDocument!['ID_Back'] != null &&
                              value.idDocument!['ID_Back'] != '' &&
                              value.idDocument!['ID_Front'] != null &&
                              value.idDocument!['ID_Front'] != '' &&
                              value.verificationPicture != null &&
                              value.verificationPicture != ''
                          ? 'Awaiting Verification'
                          : value.accountStatus == "Not Verified"
                              ? 'Not Verified'
                              : 'Verified'),
                      subtitle: Text('Account Status'),
                    ),
                    Divider(),
                    value.idDocument!['ID_Front'] != null &&
                            value.idDocument!['ID_Back'] != null &&
                            value.idDocument!['ID_Back'] != '' &&
                            value.idDocument!['ID_Front'] != ''
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      value.idDocument!['ID_Front'],
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.1,
                                      width: MediaQuery.of(context).size.width /
                                          1.9,
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 50,
                                      child: Text(
                                        'Id Front',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Image.network(
                                      value.idDocument!['ID_Back'],
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.1,
                                      width: MediaQuery.of(context).size.width /
                                          1.9,
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 50,
                                      child: Text(
                                        'Id Back',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Image.asset(
                            'assets/images/med.png',
                            height: MediaQuery.of(context).size.height / 2.8,
                            width: MediaQuery.of(context).size.width,
                          ),
                    Divider(),
                    value.verificationPicture != null &&
                            value.verificationPicture != ''
                        ? Text(
                            'Verification Selfie',
                            style: TextStyle(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          )
                        : SizedBox(),
                    value.verificationPicture != null &&
                            value.verificationPicture != ''
                        ? Image.network(value.verificationPicture!)
                        : SizedBox(),
                  ],
                ),
              );
            },
            selector: (context, p1) => p1.userData!,
          );
        },
      )),
    );
  }
}
