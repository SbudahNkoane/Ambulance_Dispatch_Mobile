// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';

import 'package:ambulance_dispatch_application/View_Models/Paramedic_Management/paramedic_management.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AmbulanceTrackingPage extends StatefulWidget {
  const AmbulanceTrackingPage({super.key});

  @override
  State<AmbulanceTrackingPage> createState() => _AmbulanceTrackingPageState();
}

class _AmbulanceTrackingPageState extends State<AmbulanceTrackingPage> {
  Completer<GoogleMapController> _googleMapController = Completer();
  Location? _location;
  LocationData? _currentLocation;
  CameraPosition? _cameraPosition;
  GeoPoint? point;
  Marker? ambulance;
  Marker? requester;
  Set<Polyline> _polyLines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Uint8List? imageData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? subscriber;
  BitmapDescriptor ambulanceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor requesterIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    _init();
    setCustomMarkerIcon();
    super.initState();
  }

  // @override
  // void dispose() {
  //   subscriber!.cancel();
  //   super.dispose();
  // }

  _init() async {
    _location = Location();
    point = context
        .read<TicketManager>()
        .bookedTicket!
        .dispatchedAmbulance!['Ambulance']['RealTime_Location'] as GeoPoint;
    _cameraPosition = CameraPosition(
        target: LatLng(
            point!.latitude,
            point!
                .longitude), // this is just the example lat and lng for initializing
        zoom: 12);
    // imageData = await getMarkerIcon();

    //updateMarker(point!, imageData!);

    moveToPosition(LatLng(point!.latitude, point!.longitude));
    await _initLocation();
  }

  updateMarker(GeoPoint newLoc) async {
    ambulance = Marker(
      markerId: MarkerId('ambulance'),
      position: LatLng(newLoc.latitude, newLoc.longitude),
      icon: ambulanceIcon,
    );

    setState(() {});
  }

  _initLocation() async {
    subscriber = database
        .collection('Ticket')
        .doc(context.read<TicketManager>().bookedTicket!.ticketId)
        .snapshots()
        .listen((event) {
      point = event.data()!['Dispatched_Ambulance']['Ambulance']
          ['RealTime_Location'] as GeoPoint;
      // updateMarker(point!, imageData!);
      updateMarker(point!);
      setPolylines();
      moveToPosition(LatLng(point!.latitude, point!.longitude));
    });
  }

  setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(5, 5),
              platform: TargetPlatform.android,
            ),
            'assets/images/ambulance_top.png')
        .then((icon) {
      ambulanceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            'assets/images/requester.png')
        .then((icon) {
      requesterIcon = icon;
    });
  }

  Future<Uint8List> getMarkerIcon() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/healthcare.png");
    return byteData.buffer.asUint8List();
  }

  // updateMarker(GeoPoint newlocation, Uint8List imageData) {
  //   setState(() {
  //     marker = Marker(
  //       markerId: MarkerId('Ambulance'),
  //       position: LatLng(newlocation.latitude, newlocation.longitude),
  //       // rotation: newlocation.heading!,
  //       draggable: false,
  //       flat: true,
  //       icon: BitmapDescriptor.fromBytes(imageData),
  //     );
  //   });
  // }

  moveToPosition(LatLng latlng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 15),
      ),
    );
  }

  setPolylines() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBhIh0xzIHgbsmCy4pdSWqMUHY68MEjwPA',
        PointLatLng(point!.latitude, point!.longitude),
        PointLatLng(
            context.read<TicketManager>().bookedTicket!.pickUpLocation.latitude,
            context
                .read<TicketManager>()
                .bookedTicket!
                .pickUpLocation
                .longitude),
        //  PointLatLng(current.latitude, current.longitude),
        //  PointLatLng(destination.latitude, destination.longitude));
      );
      if (result.status == 'OK') {
        polylineCoordinates = [];
        for (var element in result.points) {
          polylineCoordinates.add(LatLng(element.latitude, element.longitude));
        }
        setState(() {
          _polyLines.add(
            Polyline(
              color: Colors.blue,
              width: 7,
              points: polylineCoordinates,
              polylineId: PolylineId('polyline'),
            ),
          );
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        panel: Center(
          child: Text('data'),
        ),
        body: GoogleMap(
          onMapCreated: (controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
            setPolylines();
          },
          markers: {
            Marker(
              markerId: MarkerId('ambulance'),
              icon: ambulanceIcon,
              position: LatLng(point!.latitude, point!.longitude),
            ),
            Marker(
              markerId: MarkerId('req'),
              icon: requesterIcon,
              position: LatLng(
                  context
                      .read<TicketManager>()
                      .bookedTicket!
                      .pickUpLocation
                      .latitude,
                  context
                      .read<TicketManager>()
                      .bookedTicket!
                      .pickUpLocation
                      .longitude),
            ),
          },
          polylines: _polyLines,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: _cameraPosition!,
        ),
      ),
    );
  }
}
