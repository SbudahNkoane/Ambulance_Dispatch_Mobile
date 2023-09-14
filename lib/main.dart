import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF005DF4)),
        useMaterial3: true,
      ),
      initialRoute: AppLevelRouteManager.splashPage,
      onGenerateRoute: AppLevelRouteManager.generateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: const Color.fromARGB(255, 174, 131, 248),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Users"),
                            Text("20"),
                          ],
                        )),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: const Color.fromARGB(255, 174, 131, 248),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Total Tickets"),
                              Text("50"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: const Color.fromARGB(255, 174, 131, 248),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ambulances"),
                              Text("10"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: const Color.fromARGB(255, 174, 131, 248),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ambulances"),
                              Text("10"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [
                    DataColumn2(
                      label: Text('Column A'),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Text('Column B'),
                    ),
                    DataColumn(
                      label: Text('Column C'),
                    ),
                    DataColumn(
                      label: Text('Column D'),
                    ),
                    DataColumn(
                      label: Text('Column NUMBERS'),
                      numeric: true,
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    100,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text('A' * (10 - index % 10))),
                        DataCell(Text('B' * (10 - (index + 5) % 10))),
                        DataCell(Text('C' * (15 - (index + 5) % 10))),
                        DataCell(Text('D' * (15 - (index + 10) % 10))),
                        DataCell(Text(((index + 0.1) * 25.4).toString()))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
