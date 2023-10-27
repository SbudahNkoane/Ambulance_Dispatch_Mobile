// ignore_for_file: use_build_context_synchronously

import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class UserRequestFromPage extends StatefulWidget {
  const UserRequestFromPage({super.key});

  @override
  State<UserRequestFromPage> createState() => _UserRequestFromPageState();
}

class _UserRequestFromPageState extends State<UserRequestFromPage> {
  TextEditingController descriptionController = TextEditingController();
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
          child: Stack(
            children: [
              SingleChildScrollView(
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
                              controller: descriptionController,
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
                          const Text(
                            'Pick Up Location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width / 1.05,
                            child: Card(
                              color: const Color.fromARGB(255, 223, 223, 223),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    const Text('Use My Device Location'),
                                    Checkbox(
                                      value: _useCurrentLocation,
                                      onChanged: (value) async {
                                        final location = await context
                                            .read<UserManager>()
                                            .getUserLocation();

                                        if (location == null) {
                                          locator
                                              .get<NavigationAndDialogService>()
                                              .showSnackBar1(
                                                  message:
                                                      'We cannot access your location without your permission',
                                                  title:
                                                      'Your Location is required',
                                                  context: context);
                                        } else {
                                          _useCurrentLocation = value!;
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    context
                                                .read<UserManager>()
                                                .currentAddress !=
                                            null
                                        ? Selector<UserManager, Placemark>(
                                            selector: (p0, p1) =>
                                                p1.currentAddress!,
                                            builder: (context, value, child) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text('City:'),
                                                      Text('${value.locality}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text('Street:'),
                                                      Text('${value.street}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text('Suburb:'),
                                                      Text(
                                                          '${value.subLocality}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                          'Postal Code:'),
                                                      Text(
                                                          '${value.postalCode}'),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 20,
                                    ),

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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AppBlueButton(
                              onPressed: () async {
                                Ticket newTicket = Ticket(
                                  emergencyLevel: null,
                                  dispatchedAmbulance: null,
                                  closedAt: null,
                                  managedBy: null,
                                  ticketId: '',
                                  userId: context
                                      .read<UserAuthentication>()
                                      .currentUser!
                                      .uid,
                                  pickUpLocation: GeoPoint(
                                    context
                                        .read<UserManager>()
                                        .currentLocation!
                                        .latitude,
                                    context
                                        .read<UserManager>()
                                        .currentLocation!
                                        .longitude,
                                  ),
                                  description:
                                      descriptionController.text.trim(),
                                  bookedAt: Timestamp.now(),
                                  status: "Searching for an Ambulance",
                                );
                                final request = await context
                                    .read<TicketManager>()
                                    .submitTicket(
                                      context
                                          .read<UserAuthentication>()
                                          .currentUser!
                                          .uid,
                                      newTicket,
                                    );
                                if (request != 'OK') {
                                  locator
                                      .get<NavigationAndDialogService>()
                                      .showSnackBar(
                                          message: request,
                                          title: 'Oops. An error occured!');
                                } else {
                                  Navigator.of(context).popAndPushNamed(
                                      AppRouteManager.userTicketTrackingPage);
                                }
                              },
                              text: 'Request Now'),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
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
              Selector<TicketManager, Tuple2>(
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
      ),
    );
  }
}
