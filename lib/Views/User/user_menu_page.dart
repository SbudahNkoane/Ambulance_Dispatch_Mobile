import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/Views/App%20Level/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserMenuPage extends StatefulWidget {
  const UserMenuPage({super.key});

  @override
  State<UserMenuPage> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        children: [
          const Text('Your Profile'),
          const SizedBox(
            height: 10,
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRouteManager.userProfilePage);
              },
              title: const Text('Profile'),
              subtitle: const Text('Sibusiso Nkoane'),
              leading: Selector<Authentication, fireAuth.User>(
                selector: (p0, p1) => p1.currentUser!,
                builder: (context, value, child) {
                  return CircleAvatar(
                    foregroundImage: value.photoURL != null
                        ? NetworkImage(value.photoURL!)
                        : const AssetImage('assets/images/med.png')
                            as ImageProvider,
                    backgroundColor: Colors.transparent,
                    radius: 25,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Verify Account'),
          const SizedBox(
            height: 10,
          ),
          Card(
            child: ListTile(
              onTap: () {},
              subtitle: Text('for verification'),
              title: Text('Apply'),
              leading: Icon(Icons.check),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
          ),
          Card(
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 30,
                      child: AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 247, 248, 249),
                        shape: RoundedRectangleBorder(),
                        title: Text('Log Out'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text('Are you sure want to logout??'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              final result = await context
                                  .read<Authentication>()
                                  .logoutUser();
                              if (result == 'OK') {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const LoginScreen(),
                                    ),
                                    (route) => false);
                              } else {
                                print(result);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              title: Text('Logout'),
              leading: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
