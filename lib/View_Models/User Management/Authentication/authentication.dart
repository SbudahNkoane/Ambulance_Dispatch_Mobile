import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as fireBaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication with ChangeNotifier {
  fireBaseAuth.User? _currentUser;
  fireBaseAuth.User? get currentUser => _currentUser;

  fireBaseAuth.FirebaseAuth authentication = fireBaseAuth.FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

//========REGISTER USER ===============
  Future<fireBaseAuth.User?> registerNewUser(
      String email, String password, User newUser) async {
    try {} on fireBaseAuth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

//====== Check if user exist ======

  //========= LOGIN USER ==========
  Future<fireBaseAuth.User?> loginUser(String email, String password) async {
    try {
      fireBaseAuth.UserCredential userCredential =
          await fireBaseAuth.FirebaseAuth.instance
              .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
              .then((value) {
        _currentUser = value.user;
        return value;
      });
      return userCredential.user;
    } on fireBaseAuth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

//========= LOG OUT USER ==========
  void logoutUser() {
    authentication.signOut();
  }
}
