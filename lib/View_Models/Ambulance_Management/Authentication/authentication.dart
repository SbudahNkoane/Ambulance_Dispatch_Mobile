import 'package:ambulance_dispatch_application/Models/user.dart';
import 'package:flutter/foundation.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as fireBaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthentication with ChangeNotifier {
  fireBaseAuth.User? _currentUser;
  fireBaseAuth.User? get currentUser => _currentUser;

  fireBaseAuth.FirebaseAuth authentication = fireBaseAuth.FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

//========REGISTER USER ===============
  Future<fireBaseAuth.User?> registerNewUser(
      String email, String password, User newUser) async {
    try {} on fireBaseAuth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

//====== Check if user exist ======

  //========= LOGIN USER ==========
  Future<String> loginUser(String email, String password) async {
    String state = 'OK';
    try {
      await fireBaseAuth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        if (value.user!.emailVerified != false) {
          state = 'Confirm Your email to sign in';
        } else {
          _currentUser = value.user;
        }

        return value;
      });
    } on fireBaseAuth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        state = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        state = 'Wrong password provided for that user.';
      }
    }
    return state;
  }

//========= LOG OUT USER ==========
  Future<String> logoutUser() async {
    String state = 'OK';
    try {
      authentication.signOut();
      _currentUser = null;
    } catch (e) {
      state = e.toString();
    }
    return state;
  }
}
