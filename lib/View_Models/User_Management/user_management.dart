import 'dart:io';

import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as loc;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class UserManager with ChangeNotifier {
  Placemark? _addressName;
  Placemark? get currentAddress => _addressName;
  loc.Geolocator _geolocator = loc.Geolocator();
  late bool _serviceEnabled;
  late loc.LocationPermission _permission;

  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  bool _showprogress = false;
  bool get showProgress => _showprogress;

  String _userprogresstext = "";
  String get userProgressText => _userprogresstext;

  User? _userData;
  User? get userData => _userData;

  Stream? _userStream;
  Stream? get userStream => _userStream;
  loc.Position? _currentLocation;
  loc.Position? get currentLocation => _currentLocation;
  Stream userStreamer() {
    _userStream =
        database.collection('User').doc(_userData!.userID).snapshots();
    return _userStream!;
  }

  Future<String> getUserLocation() async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Setting location...';
    notifyListeners();

    try {
      _serviceEnabled = await loc.Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled');
      } else {
        _permission = await loc.Geolocator.checkPermission();
        if (_permission == loc.LocationPermission.denied) {
          _permission = await loc.Geolocator.requestPermission();
          if (_permission == loc.LocationPermission.denied ||
              _permission == loc.LocationPermission.deniedForever) {
            _showprogress = false;
            notifyListeners();
            return 'You have denied permissions to access your location';
          } else if (_permission == loc.LocationPermission.always ||
              _permission == loc.LocationPermission.whileInUse) {
            _currentLocation = await loc.Geolocator.getCurrentPosition(
              desiredAccuracy: loc.LocationAccuracy.high,
            );
            List<Placemark> placemark = await placemarkFromCoordinates(
                    _currentLocation!.latitude, _currentLocation!.longitude)
                .onError((error, stackTrace) {
              throw state = error.toString();
            });

            _addressName = placemark[0];
          }
        } else {
          _currentLocation = await loc.Geolocator.getCurrentPosition(
            desiredAccuracy: loc.LocationAccuracy.high,
          );
          List<Placemark> placemark = await placemarkFromCoordinates(
                  _currentLocation!.latitude, _currentLocation!.longitude)
              .onError((error, stackTrace) {
            throw state = error.toString();
          });

          _addressName = placemark[0];
        }
      }
    } on PlatformException catch (e) {
      state = e.message.toString();
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return state;
  }

  Future<User?> getCurrentUserData(String userID) async {
    _showprogress = true;
    _userprogresstext = 'Setting up profile...';
    notifyListeners();
    final docRef = database.collection("User").doc(userID);

    try {
      await docRef.get().then(
        (DocumentSnapshot doc) {
          _userData = User.fromJson(doc.data() as Map<String, dynamic>);
        },
      );
      docRef.snapshots().listen(
        (event) {
          _userData = User.fromJson(event.data() as Map<String, dynamic>);
          notifyListeners();
        },
        onDone: () async {},
      );
      if (_userData!.userID == null) {
        await docRef.set(
          {'User_ID': userID},
          SetOptions(merge: true),
        ).onError((error, stackTrace) {});
      }
    } catch (e) {
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return _userData;
  }

  Future<String> applyForVerification(
      {required File selfie,
      required String userID,
      required File idFront,
      required File idBack}) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Sending application...';
    notifyListeners();
    TaskSnapshot? uploadedSelfie;
    TaskSnapshot? uploadedIDBack;
    TaskSnapshot? uploadedIDFront;
    final userInfo = database.collection("User").doc(userID);
    final storageRef = FirebaseStorage.instance.ref();
    final selfiePath =
        storageRef.child('$userID/Images/Verification/Selfie.jpg');
    final idFrontPath =
        storageRef.child('$userID/Images/Verification/ID-Front.jpg');
    final idBackPath =
        storageRef.child('$userID/Images/Verification/ID-Back.jpg');
    try {
      await selfiePath.putFile(selfie).then((uploaded) async {
        uploadedSelfie = uploaded;
      }).onError((error, stackTrace) {});
      await idBackPath.putFile(idBack).then((uploaded) {
        uploadedIDBack = uploaded;
      }).onError((error, stackTrace) {});
      await idFrontPath.putFile(idFront).then((uploaded) {
        uploadedIDFront = uploaded;
      }).onError((error, stackTrace) {});
      await userInfo.set(
        {
          'Verification_Picture': await uploadedSelfie!.ref.getDownloadURL(),
          'ID_Document': {
            'ID_Front': await uploadedIDFront!.ref.getDownloadURL(),
            'ID_Back': await uploadedIDBack!.ref.getDownloadURL(),
          }
        },
        SetOptions(merge: true),
      ).onError((error, stackTrace) {});
    } on FirebaseException catch (error) {
      state = error.message.toString();
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return state;
  }

  Future<String> updateProfilePicture(
      {required ImageSource source,
      required String userID,
      required bool remove}) async {
    final docRef = database.collection("User").doc(userID);
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
