// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

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
  Location? _location;
  LocationData? _currentLocation;
  CameraPosition? _cameraPosition;
  Set<Polyline> _polyLines = Set<Polyline>();
  Marker? ambulanceMarker;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  StreamSubscription<LocationData>? subscriber;

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
    subscriber!.cancel();
    super.dispose();
  }

  _init() async {
    _location = Location();

    _cameraPosition = const CameraPosition(
        target: LatLng(-29.0852,
            26.1596), // this is just the example lat and lng for initializing
        zoom: 12);
    await _initLocation();
    // moveToCurrentLocation();
  }

  setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size.fromRadius(5)),
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
    await moveToPosition(LatLng(
        context.read<ParamedicManager>().currentParamedicLocation!.latitude!,
        context.read<ParamedicManager>().currentParamedicLocation!.longitude!));
    subscriber = context
        .read<ParamedicManager>()
        .loc
        .onLocationChanged
        .listen((newLocation) async {
      context.read<ParamedicManager>().setParamedicLocation = newLocation;
      if (context.read<ParamedicManager>().paramedicData!.inAmbulance!.status ==
          "Dispatched") {
        await database
            .collection('Ticket')
            .doc(context.read<ParamedicManager>().dispatchTicket!.ticketId)
            .update({
          'Dispatched_Ambulance.Ambulance.RealTime_Location':
              GeoPoint(newLocation.latitude!, newLocation.longitude!),
        });
        await database
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
      setPolylines();
      updateMarker(newLocation);
    });
  }

  updateMarker(LocationData newLoc) async {
    ambulanceMarker = Marker(
      markerId: MarkerId('ambulance'),
      position: LatLng(newLoc.latitude!, newLoc.longitude!),
      icon: ambulanceIcon,
    );
    setState(() {});
  }

  moveToPosition(LatLng latlng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 16),
      ),
    );
  }

  setPolylines() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBhIh0xzIHgbsmCy4pdSWqMUHY68MEjwPA',
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
      );
      if (result.status == 'OK') {
        polylineCoordinates = [];
        for (var element in result.points) {
          polylineCoordinates.add(LatLng(element.latitude, element.longitude));
        }
        setState(() {
          _polyLines.add(
            Polyline(
              points: polylineCoordinates,
              polylineId: const PolylineId('polyline'),
            ),
          );
        });
      }
    } catch (e) {
      locator
          .get<NavigationAndDialogService>()
          .showSnackBar(message: e.toString(), title: 'An Error Occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          panel: const Center(
            child: Text('data'),
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
                setPolylines();
              },
              polylines: _polyLines,

              // myLocationEnabled: true,
              initialCameraPosition: _cameraPosition!,
            ),
          )),
    );
  }
}
