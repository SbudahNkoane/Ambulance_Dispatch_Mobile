import 'dart:io';

import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserManager with ChangeNotifier {
  final storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? _userData;
  User? get userData => _userData;

  final Stream _userStream =
      FirebaseFirestore.instance.collection('User').snapshots();
  Stream get userStream => _userStream;

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

  Future<String> updateProfilePicture(ImageSource source, String userID) async {
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
    }
    notifyListeners();
    return '';
  }
}
