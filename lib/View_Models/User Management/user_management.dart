import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManager with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? _userData;
  User? get userData => _userData;

  Future<User?> getCurrentUserData(String userID) async {
    final docRef = db.collection("User").doc(userID);
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

    return _userData;
  }
}
