import 'dart:async';

import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController addressController = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static late LatLng _initialPostion;
  //= LatLng(-29.1218, 26.2093);
  LatLng _lastPosition = _initialPostion;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _onAddMarkerPressed() {
    setState(() {
      _markers.add(
        Marker(
          position: _lastPosition,
          infoWindow: InfoWindow(
            title: 'Here',
            snippet: 'You are',
          ),
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(_lastPosition.toString()),
        ),
      );
    });
  }

  // @override
  // void initState() {
  //   _onMapCreated;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: _onCameraMove,
            markers: _markers,
            myLocationEnabled: true,
            mapType: MapType.terrain,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPostion,
              zoom: 13,
            ),
          ),
          Positioned(
            right: 15,
            left: 15,
            top: 60,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: AppConstants().appDarkWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(87, 0, 0, 0),
                      offset: Offset(1, 5),
                      blurRadius: 10,
                      spreadRadius: 3,
                    )
                  ]),
              child: TextField(
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 10),
                    height: 10,
                    width: 10,
                    child: Icon(Icons.add_location),
                  ),
                  hintText: 'Pick up location',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _onAddMarkerPressed,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: AppConstants().appDarkBlue,
                foregroundColor: AppConstants().appDarkWhite,
                child: const Icon(Icons.add_location, size: 36.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
