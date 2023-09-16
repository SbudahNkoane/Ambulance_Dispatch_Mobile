import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:flutter/material.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        children: [
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRouteManager.userProfilePage);
              },
              title: const Text('Profile'),
              subtitle: const Text('Sibusiso Nkoane'),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.transparent,
                radius: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Apply for Account Verification'),
          const SizedBox(
            height: 10,
          ),
          const Card(
            child:
                ListTile(title: Text('Apply'), leading: Icon(Icons.approval)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
          ),
          const Card(
            child: ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
