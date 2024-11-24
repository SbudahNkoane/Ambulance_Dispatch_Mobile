// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:ambulance_dispatch_application/Keys/my_api_keys.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TicketDispatchPage extends StatefulWidget {
  const TicketDispatchPage({super.key});

  @override
  State<TicketDispatchPage> createState() => _TicketDispatchPageState();
}

class _TicketDispatchPageState extends State<TicketDispatchPage> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  final Set<Polyline> _polyLines = <Polyline>{};
  Marker? ambulanceMarker;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  StreamSubscription<LocationData>? subscriber;
  int dropdownValue = 1;
  List<int> levels = [1, 2, 3, 4];

  BitmapDescriptor ambulanceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor requesterIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    _init();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  void dispose() {
    if (context.mounted == false) {
      subscriber!.cancel();
    }
    super.dispose();
  }

  _init() async {
    _cameraPosition =
        const CameraPosition(target: LatLng(-29.0852, 26.1596), zoom: 12);
    await _initLocation();
    // moveToCurrentLocation();
  }

  setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size.fromRadius(2)),
            'assets/images/ambulance_top.png')
        .then((icon) {
      ambulanceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/requester.png')
        .then((icon) {
      requesterIcon = icon;
    });
  }

  _initLocation() async {
    if (mounted) {
      await moveToPosition(
        LatLng(
          context.read<ParamedicManager>().currentParamedicLocation!.latitude!,
          context.read<ParamedicManager>().currentParamedicLocation!.longitude!,
        ),
      );
      subscriber = context
          .read<ParamedicManager>()
          .loc
          .onLocationChanged
          .listen((newLocation) async {
        context.read<ParamedicManager>().setParamedicLocation = newLocation;
        if (context
                .read<ParamedicManager>()
                .paramedicData!
                .inAmbulance!
                .status ==
            "Dispatched") {
          await database
              .collection('Tickets')
              .doc(context.read<ParamedicManager>().dispatchTicket!.ticketId)
              .update({
            'Dispatched_Ambulance.Ambulance.RealTime_Location': GeoPoint(
              newLocation.latitude!,
              newLocation.longitude!,
            ),
          });
          await database
              .collection('Dispatched Ambulances')
              .doc(
                context.read<ParamedicManager>().dispatchTicket!.ticketId,
              )
              .update({
            'Ambulance.RealTime_Location': GeoPoint(
              newLocation.latitude!,
              newLocation.longitude!,
            ),
          });
        }
        await database
            .collection('Ambulances')
            .doc(
              context
                  .read<ParamedicManager>()
                  .paramedicData!
                  .inAmbulance!
                  .ambulanceId!,
            )
            .update({
          'RealTime_Location': GeoPoint(
            newLocation.latitude!,
            newLocation.longitude!,
          ),
        });
        moveToPosition(
          LatLng(
            newLocation.latitude!,
            newLocation.longitude!,
          ),
        );
        setPolyline();
        updateMarker(newLocation);
      });
    }
  }

  updateMarker(LocationData newLoc) async {
    setState(() {
      ambulanceMarker = Marker(
        markerId: const MarkerId('ambulance'),
        position: LatLng(
          newLoc.latitude!,
          newLoc.longitude!,
        ),
        icon: ambulanceIcon,
      );
    });
  }

  moveToPosition(LatLng latlng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 16),
      ),
    );
  }

  setPolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        APIKeys().googleAPI,
        PointLatLng(
            context
                .read<ParamedicManager>()
                .currentParamedicLocation!
                .latitude!,
            context
                .read<ParamedicManager>()
                .currentParamedicLocation!
                .longitude!),
        PointLatLng(
            context
                .read<ParamedicManager>()
                .dispatchTicket!
                .pickUpLocation
                .latitude,
            context
                .read<ParamedicManager>()
                .dispatchTicket!
                .pickUpLocation
                .longitude),
        travelMode: TravelMode.driving,
      );
      if (result.status == 'OK') {
        polylineCoordinates = [];
        for (var element in result.points) {
          polylineCoordinates.add(LatLng(element.latitude, element.longitude));
        }
        setState(() {
          _polyLines.add(
            Polyline(
              color: const Color.fromARGB(255, 245, 31, 31),
              points: polylineCoordinates,
              polylineId: const PolylineId('polyline'),
            ),
          );
        });
      }
    } catch (e) {
      locator.get<NavigationAndDialogService>().showSnackBar(
          context: context, message: e.toString(), title: 'An Error Occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
              panel: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text('Set emergency level'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 10,
                      ),
                      DropdownButtonFormField(
                        alignment: Alignment.centerRight,
                        value: dropdownValue,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        dropdownColor: const Color(0xFFEAEAEA),
                        decoration: InputDecoration(
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
                          fillColor: const Color(0xFFEAEAEA),
                          filled: true,
                        ),
                        items: levels.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            alignment: Alignment.center,
                            value: value,
                            child: Text(
                              '$value',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final result = await context
                                .read<ParamedicManager>()
                                .closeTicket(dropdownValue);
                            if (result == 'OK') {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Close Ticket')),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: GoogleMap(
                  markers: {
                    Marker(
                      icon: ambulanceIcon,
                      markerId: const MarkerId('Loc'),
                      position: LatLng(
                        context
                            .read<ParamedicManager>()
                            .currentParamedicLocation!
                            .latitude!,
                        context
                            .read<ParamedicManager>()
                            .currentParamedicLocation!
                            .longitude!,
                      ),
                    ),
                    Marker(
                      icon: requesterIcon,
                      markerId: const MarkerId('Des'),
                      position: LatLng(
                        context
                            .read<ParamedicManager>()
                            .dispatchTicket!
                            .pickUpLocation
                            .latitude,
                        context
                            .read<ParamedicManager>()
                            .dispatchTicket!
                            .pickUpLocation
                            .longitude,
                      ),
                    ),
                  },
                  trafficEnabled: true,
                  onMapCreated: (controller) {
                    if (!_googleMapController.isCompleted) {
                      _googleMapController.complete(controller);
                    }
                    setPolyline();
                  },
                  polylines: _polyLines,

                  // myLocationEnabled: true,
                  initialCameraPosition: _cameraPosition!,
                ),
              )),
        ],
      ),
    );
  }
}
