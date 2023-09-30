import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 17, 23, 35),
              // ignore: prefer_const_constructors
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                // ignore: prefer_const_constructors
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Nkoane Sibusiso"),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.home),
                      // ignore: prefer_const_constructors
                      title: Text("Home"),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Manage Users"),
                    ),
                    ListTile(
                      leading: Icon(Icons.file_open),
                      title: Text("Manage Tickets"),
                    ),
                    ListTile(
                      leading: Icon(Icons.card_membership),
                      title: Text("Manage Ambulances"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
