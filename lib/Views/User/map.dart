import 'dart:async';

import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController addressController = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static late LatLng _initialPostion;
  late LatLng _lastPosition;
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

  LatLng getLocation(BuildContext context) {
    _initialPostion = LatLng(
        context.read<UserManager>().currentLocation!.latitude,
        context.read<UserManager>().currentLocation!.longitude);

    return _initialPostion;
  }

  @override
  void initState() {
    _lastPosition = getLocation(context);
    _markers.add(Marker(
      position: _lastPosition,
      infoWindow: InfoWindow(
        title: 'You are here',
        snippet: 'your location',
      ),
      markerId: MarkerId(
        _lastPosition.toString(),
      ),
    ));
    _onMapCreated;

    super.initState();
  }

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
            mapType: MapType.normal,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(
                            1,
                            5,
                          ),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ]),
                child: TextField(
                  cursorColor: Colors.blue.shade900,
                  controller: addressController,
                  decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      hintText: 'Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, top: 5)),
                ),
              )
              //  Container(
              //   height: 50,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(3),
              //       color: AppConstants().appDarkWhite,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Color.fromARGB(87, 0, 0, 0),
              //           offset: Offset(1, 5),
              //           blurRadius: 10,
              //           spreadRadius: 3,
              //         )
              //       ]),
              //   child: TextField(
              //     controller: addressController,
              //     decoration: InputDecoration(
              //       suffixIcon: Container(
              //         margin: EdgeInsets.only(left: 20, top: 5, bottom: 10),
              //         height: 10,
              //         width: 10,
              //         child: Icon(
              //           Icons.location_on,
              //           color: Colors.red,
              //         ),
              //       ),
              //       icon: Container(
              //         margin: EdgeInsets.only(left: 20, top: 5, bottom: 10),
              //         height: 10,
              //         width: 10,
              //         child: Icon(
              //           Icons.location_on,
              //           color: Colors.red,
              //         ),
              //       ),
              //       hintText: 'Enter Address',
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.only(left: 15, top: 5),
              //     ),
              //   ),
              // ),
              ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  findLatLngFromAddress(addressController.text.trim());
                },
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

  Future<List<Location>?> findLatLngFromAddress(String address) async {
    List<Location>? place;
    try {
      final place = await locationFromAddress(address);
      setState(() {
        _lastPosition = LatLng(place![0].latitude, place[0].longitude);
      });
    } on PlatformException catch (e) {
    } catch (err) {
      print(err.toString());
    }

    return place;
  }
}
