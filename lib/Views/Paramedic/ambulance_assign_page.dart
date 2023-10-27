// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:ambulance_dispatch_application/Models/ambulance.dart';
import 'package:ambulance_dispatch_application/Models/paramedic.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/Ambulance_Management/ambulance_management.dart';
import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/Views/App_Level/app_progress_indicator.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AssignAmbulancePage extends StatefulWidget {
  const AssignAmbulancePage({super.key});

  @override
  State<AssignAmbulancePage> createState() => _AssignAmbulancePageState();
}

class _AssignAmbulancePageState extends State<AssignAmbulancePage> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    context.read<ParamedicManager>().paramedicData!.inAmbulance != null
        ? context.read<ParamedicManager>().trackAmbulanceDataChanges
        : null;
    _init();
    super.initState();
  }

  _init() async {
    //  _location = Location();
    _cameraPosition = const CameraPosition(
        target: LatLng(-29.0852,
            26.1596), // this is just the example lat and lng for initializing
        zoom: 12);
    await _initLocation();
  }

  //function to listen when we move position
  _initLocation() async {
    await moveToPosition(LatLng(
        context.read<ParamedicManager>().currentParamedicLocation!.latitude!,
        context.read<ParamedicManager>().currentParamedicLocation!.longitude!));
    context
        .read<ParamedicManager>()
        .loc
        .onLocationChanged
        .listen((newLocation) async {
      context.read<ParamedicManager>().setParamedicLocation = newLocation;
      if (context.read<ParamedicManager>().paramedicData!.inAmbulance!.status ==
          "Dispatched") {
        database
            .collection('Ticket')
            .doc(context.read<ParamedicManager>().dispatchTicket!.ticketId)
            .update({
          'Dispatched_Ambulance.Ambulance.RealTime_Location':
              GeoPoint(newLocation.latitude!, newLocation.longitude!),
        });
        database
            .collection('Dispatched Ambulance')
            .doc(context.read<ParamedicManager>().dispatchTicket!.ticketId)
            .update({
          'Ambulance.RealTime_Location':
              GeoPoint(newLocation.latitude!, newLocation.longitude!),
        });
      }
      await database
          .collection('Ambulance')
          .doc(context
              .read<ParamedicManager>()
              .paramedicData!
              .inAmbulance!
              .ambulanceId!)
          .update({
        'RealTime_Location':
            GeoPoint(newLocation.latitude!, newLocation.longitude!),
      });
      moveToPosition(LatLng(
          context.read<ParamedicManager>().currentParamedicLocation!.latitude!,
          context
              .read<ParamedicManager>()
              .currentParamedicLocation!
              .longitude!));
    });
  }

//========moving the camera in the map
  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: context.read<ParamedicManager>().userStreamer(),
            builder: (context, snapshot) {
              if (_googleMapController.isCompleted) {
                moveToPosition(
                  LatLng(
                      context
                          .read<ParamedicManager>()
                          .currentParamedicLocation!
                          .latitude!,
                      context
                          .read<ParamedicManager>()
                          .currentParamedicLocation!
                          .longitude!),
                );
              }
              return context
                          .read<ParamedicManager>()
                          .paramedicData!
                          .inAmbulance !=
                      null
                  ? Center(
                      child: Selector<ParamedicManager, Paramedic>(
                      selector: (p0, p1) => p1.paramedicData!,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                              child: GoogleMap(
                                myLocationEnabled: true,
                                initialCameraPosition: _cameraPosition!,
                                onMapCreated: (controller) {
                                  if (!_googleMapController.isCompleted) {
                                    _googleMapController.complete(controller);
                                  } else {
                                    // _googleMapController = controller;
                                  }
                                },
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2.4,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Ambulance Plate:',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          value.inAmbulance!.numberPlate,
                                          style: GoogleFonts.moul(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Status:',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          value.inAmbulance!.status,
                                          style: GoogleFonts.moul(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      value.inAmbulance!.status == 'Dispatched'
                                          ? 'You have been dispatched'
                                          : 'Waiting to be dispatched',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Lottie.asset(
                                      value.inAmbulance!.status == 'Dispatched'
                                          ? 'assets/animations/siren_red.json'
                                          : 'assets/animations/awaiting_dispatch.json',
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    value.inAmbulance!.status == 'Dispatched'
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              fixedSize: const Size(350, 50),
                                              foregroundColor:
                                                  AppConstants().appWhite,
                                              backgroundColor:
                                                  AppConstants().appDarkBlue,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  AppRouteManager
                                                      .paramedicTicketDispatchPage);
                                            },
                                            child: const Text(
                                              'Accept dispatch',
                                              style: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        fixedSize: const Size(350, 50),
                                        foregroundColor:
                                            AppConstants().appWhite,
                                        backgroundColor: AppConstants().appRed,
                                      ),
                                      onPressed: () async {
                                        await context
                                            .read<ParamedicManager>()
                                            .leaveAmbulance();
                                      },
                                      child: const Text(
                                        'Leave Ambulance',
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ))
                  : Selector<AmbulanceManager, List<Ambulance>>(
                      selector: (p0, p1) => p1.availableAmbulances,
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: context
                                .read<AmbulanceManager>()
                                .availableAmbulances
                                .length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                      'Ambulance Plate:${value[index].numberPlate}'),
                                  subtitle: SizedBox(
                                    height: 70,
                                    child: ListView.builder(
                                      itemCount:
                                          value[index].paramedics!.length,
                                      itemBuilder: (context, index) {
                                        return Text(value[index]
                                            .paramedics![index]['Names']);
                                      },
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 20, 61, 241),
                                      foregroundColor: const Color.fromARGB(
                                          255, 223, 223, 223),
                                    ),
                                    onPressed: () async {
                                      await context
                                          .read<ParamedicManager>()
                                          .driveAmbulance(value[index]);
                                    },
                                    child: Text(value[index].paramedics!.isEmpty
                                        ? 'Drive now'
                                        : 'Join Crew'),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
            },
          ),
          Selector<ParamedicManager, Tuple2>(
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
    );
  }
}
