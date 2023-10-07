import 'dart:io';

import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as loc;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class UserManager with ChangeNotifier {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  final storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? _userData;
  User? get userData => _userData;

  final Stream _userStream =
      FirebaseFirestore.instance.collection('User').snapshots();
  Stream get userStream => _userStream;

  Future<String> getUserLocation() async {
    loc.Position position = await loc.Geolocator.getCurrentPosition(
      desiredAccuracy: loc.LocationAccuracy.high,
    );

    // List placemark = loc.Geolocator.
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return '';
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _locationData = await location.getLocation();
        return '';
      }
    }

    return '';
  }

  Future<User?> getCurrentUserData(String userID) async {
    final docRef = db.collection("User").doc(userID);
    docRef.snapshots().listen(
      (event) {
        _userData = User.fromJson(event.data() as Map<String, dynamic>);
        print(_userData);
      },
      onDone: () {},
    );
    await docRef.set(
      {'User_ID': userID},
      SetOptions(merge: true),
    ).then((value) async {
      await docRef.get().then(
        (DocumentSnapshot doc) {
          _userData = User.fromJson(doc.data() as Map<String, dynamic>);
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }).onError((error, stackTrace) {});
    notifyListeners();
    return _userData;
  }

  Future<String> updateProfilePicture(
      {required ImageSource source,
      required String userID,
      required bool remove}) async {
    final docRef = db.collection("User").doc(userID);
    final storageRef = FirebaseStorage.instance.ref();
    final path =
        storageRef.child('$userID/Images/Profile Picture/profilePicture.jpg');
    XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        await path.putFile(imageFile).then((p) async {
          if (p.state == TaskState.success) {
            String uploaded = await p.ref.getDownloadURL();
            print(uploaded);
            await docRef.set(
              {'Profile_Picture': uploaded},
              SetOptions(merge: true),
            ).then((value) async {
              await docRef.get().then(
                (DocumentSnapshot doc) {
                  _userData = User.fromJson(doc.data() as Map<String, dynamic>);
                },
                onError: (e) => print("Error getting document: $e"),
              );
            }).onError((error, stackTrace) {});
          }
        });
      } on FirebaseException catch (e) {}
    } else if (remove == true) {
      await path
          .putFile(File(_userData!.gender == 'Male'
              ? 'assets/images/profileMale'
              : 'assets/images/profileFemale'))
          .then((p0) async {
        if (p0.state == TaskState.success) {
          String uploaded = await p0.ref.getDownloadURL();
          await docRef.set(
            {
              'Profile_Picture': uploaded,
            },
            SetOptions(merge: true),
          ).then((value) async {
            await docRef.get().then(
              (DocumentSnapshot doc) {
                _userData = User.fromJson(doc.data() as Map<String, dynamic>);
              },
              onError: (e) => print("Error getting document: $e"),
            );
          });
        }
      });
    }
    notifyListeners();
    return '';
  }
}
