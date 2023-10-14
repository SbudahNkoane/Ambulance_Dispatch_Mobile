import 'package:ambulance_dispatch_application/Models/user.dart' as user;
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UserAuthentication with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _showprogress = false;
  bool get showProgress => _showprogress;

  String _userprogresstext = "";
  String get userProgressText => _userprogresstext;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

//========REGISTER USER ===============
  Future<User?> registerNewUser(
      String email, String password, user.User userInfo) async {
    try {
      await authentication
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((registeredUser) async {
        await database
            .collection('User')
            .doc(registeredUser.user!.uid)
            .set(userInfo.toJson())
            .onError((error, stackTrace) {
          print(error);
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    return null;
  }

//====== Check if user exist ======

  //========= LOGIN USER ==========
  Future<String> loginUser(String email, String password) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Signing in...';
    notifyListeners();
    try {
      await authentication
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .onError((error, stackTrace) {
        state = error.toString();
        return Future.error(error.toString());
      }).then((value) {
        if (value.user!.emailVerified != false) {
          state = 'Confirm Your email to sign in';
        } else {
          _currentUser = value.user;
        }

        return value;
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        state = 'No user found for that email.';
      } else if (error.code == 'wrong-password') {
        state = 'Wrong password provided for that user.';
      }
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
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
