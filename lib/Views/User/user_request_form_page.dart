import 'dart:async';

import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/User%20Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserRequestFromPage extends StatefulWidget {
  const UserRequestFromPage({super.key});

  @override
  State<UserRequestFromPage> createState() => _UserRequestFromPageState();
}

class _UserRequestFromPageState extends State<UserRequestFromPage> {
  bool _useCurrentLocation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppConstants().appDarkWhite,
        centerTitle: true,
        toolbarHeight: 240,
        title: Column(
          children: [
            Image.asset(
              AppConstants().logoWithWhiteBackground,
              height: 150,
              width: 150,
            ),
            const Text("Request Form"),
          ],
        ),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Your Are nearly done'),
              const SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                  children: [
                    const Text(
                        'Give a short description of the Patient\'s condition'),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        maxLength: 100,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
                        cursorHeight: 26,
                        decoration: InputDecoration(
                          label: const Text('Type here...'),
                          labelStyle: GoogleFonts.orelegaOne(),
                          fillColor: AppConstants().appGrey,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 59, 59, 59),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 59, 59, 59),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 59, 59, 59),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              width: 2,
                              color: AppConstants().appDarkBlue,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.view_timeline_sharp,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Pick Up Location'),
                    SizedBox(
                      height: 600,
                      width: MediaQuery.of(context).size.width / 1.05,
                      child: Card(
                        color: const Color.fromARGB(255, 196, 196, 196),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              const Text('Use My Device Location'),
                              Checkbox(
                                value: _useCurrentLocation,
                                onChanged: (value) async {
                                  setState(() {
                                    print(value);
                                    _useCurrentLocation = value!;
                                  });
                                  if (_useCurrentLocation == true) {
                                    context
                                        .read<UserManager>()
                                        .getUserLocation();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('OR'),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRouteManager.userMapPage);
                                  },
                                  child: Text('Choose')),
                              // SizedBox(
                              //   height: 90,
                              //   width: 1000,
                              //   child: GoogleMap(
                              //     onMapCreated: _onMapCreated,
                              //     initialCameraPosition: CameraPosition(
                              //       target: _center,
                              //       zoom: 11.0,
                              //     ),
                              //   ),
                              // ),
                              const Text('Street Address'),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                cursorHeight: 24,
                                decoration: InputDecoration(
                                  label: const Text('Type here...'),
                                  labelStyle: GoogleFonts.orelegaOne(),
                                  fillColor: AppConstants().appGrey,
                                  filled: true,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: AppConstants().appDarkBlue,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.pin_drop,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('City'),
                                  Text('State/Province')
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      cursorColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      cursorHeight: 26,
                                      decoration: InputDecoration(
                                        label: const Text('Type here...'),
                                        labelStyle: GoogleFonts.orelegaOne(),
                                        fillColor: AppConstants().appGrey,
                                        filled: true,
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppConstants().appDarkBlue,
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.view_timeline_sharp,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      cursorColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      cursorHeight: 26,
                                      decoration: InputDecoration(
                                        label: const Text('Type here...'),
                                        labelStyle: GoogleFonts.orelegaOne(),
                                        fillColor: AppConstants().appGrey,
                                        filled: true,
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          // borderSide: const BorderSide(
                                          //   width: 1,
                                          //   color:
                                          //       Color.fromARGB(255, 59, 59, 59),
                                          // ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          // borderSide: BorderSide(
                                          //   width: 2,
                                          //   color: AppConstants().appDarkBlue,
                                          // ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.view_timeline_sharp,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Postal/Zip Code'),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 75, right: 75),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    cursorColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    cursorHeight: 24,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.pin_drop,
                                        size: 18,
                                      ),
                                      hintText: 'Type here...',
                                      hintStyle: GoogleFonts.orelegaOne(),
                                      fillColor: AppConstants().appGrey,
                                      filled: true,
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 59, 59, 59),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 59, 59, 59),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 59, 59, 59),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: AppConstants().appDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppBlueButton(onPressed: () {}, text: 'Request Now'),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
