import 'package:ambulance_dispatch_application/Models/user.dart' as user;
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/foundation.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<String> registerNewUser(
      String email, String password, user.User userInfo) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Creating account...';
    notifyListeners();
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
            .then((value) {
          _userprogresstext = 'Saving data...';
          notifyListeners();
          database
              .collection('User')
              .doc(registeredUser.user!.uid)
              .update({'User_ID': registeredUser.user!.uid});
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            print(error);
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        state = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        state = 'The account already exists for that email.';
      } else {
        state = e.message.toString();
      }
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return state;
  }

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
      } else {
        state = error.message.toString();
      }
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return state;
  }

  Future<String> resetPassword(String email) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Sending link..';
    notifyListeners();

    try {
      authentication.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      state = e.message.toString();
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
