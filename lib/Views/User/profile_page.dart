import 'package:flutter/material.dart';

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
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              right: 10,
              left: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Stack(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          foregroundImage: AssetImage('assets/images/logo.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 120,
                      left: 100,
                      child: CircleAvatar(
                        child: Center(
                          child: Icon(Icons.camera_enhance),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Sibusiso Nkoane'),
                const Text('0 Tickets'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Not Verified'),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Apply for Verification'))
                  ],
                ),
                const Text('About'),
                const Divider(),
                const Text('Contact info'),
                const ListTile(
                  leading: CircleAvatar(
                    child: Center(
                      child: Icon(Icons.phone),
                    ),
                  ),
                  title: Text('078 360 0856'),
                  subtitle: Text('Mobile Number'),
                ),
                const ListTile(
                  leading: CircleAvatar(
                    child: Center(
                      child: Icon(Icons.mail),
                    ),
                  ),
                  title: Text('sbudahnkoane1@gmail.com'),
                  subtitle: Text('Email'),
                ),
                const Divider(),
                const Text('Basic info'),
                const ListTile(
                  leading: CircleAvatar(
                    child: Center(
                      child: Icon(Icons.person_2),
                    ),
                  ),
                  title: Text('Male'),
                  subtitle: Text('Gender'),
                ),
                const ListTile(
                  leading: CircleAvatar(
                    child: Center(
                      child: Icon(Icons.person_2),
                    ),
                  ),
                  title: Text('20'),
                  subtitle: Text('Age'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
