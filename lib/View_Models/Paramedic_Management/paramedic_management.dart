import 'package:ambulance_dispatch_application/Models/ambulance.dart';
import 'package:ambulance_dispatch_application/Models/paramedic.dart';
import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';

class ParamedicManager with ChangeNotifier {
  late bool _serviceEnabled;
  geo.Position? _currentLocation;
  geo.Position? get currentLocation => _currentLocation;

  final Location _loc = Location();
  Location get loc => _loc;

  LocationData? _userLocation;
  LocationData? get currentParamedicLocation => _userLocation;
  set setParamedicLocation(LocationData location) {
    _userLocation = location;
    notifyListeners();
  }

  set setCurrentLocation(geo.Position location) {
    _currentLocation = location;
    notifyListeners();
  }

  bool _showprogress = false;
  bool get showProgress => _showprogress;

  Ticket? _dispatchTicket;
  Ticket? get dispatchTicket => _dispatchTicket;

  Paramedic? _paramedicData;
  Paramedic? get paramedicData => _paramedicData;

  String _userprogresstext = "";
  String get userProgressText => _userprogresstext;
  Stream? _userStream;
  Stream? get userStream => _userStream;
  Stream userStreamer() {
    _userStream = database
        .collection('Paramedics')
        .doc(_paramedicData!.userID)
        .snapshots();
    return _userStream!;
  }

  void trackParamedicDataChanges() {
    database
        .collection('Paramedics')
        .doc(_paramedicData!.userID)
        .snapshots()
        .listen((event) {
      if (_paramedicData?.inAmbulance != null) {}
      _paramedicData = Paramedic.fromJson(event.data());
    });
  }

  void trackAmbulanceDataChanges(QuerySnapshot<Map<String, dynamic>> snapshot) {
    database
        .collection('Ambulances')
        .doc(snapshot.docs[0].id)
        .snapshots()
        .listen((event) async {
      if (event.data()!['Status'] == 'Dispatched') {
        await database
            .collection('Dispatched Ambulances')
            .where('Ambulance.Number_Plate',
                isEqualTo: event.data()!['Number_Plate'])
            .get()
            .then((dispatchedAmbulance) async {
          await database
              .collection('Tickets')
              .doc(dispatchedAmbulance.docs[0].id)
              .get()
              .then((ticket) {
            _dispatchTicket = Ticket.fromJson(ticket.data());
          });
        });
      }
      var paramedics = event.data()!['Paramedics'];
      if (paramedics.isEmpty) {
        await database
            .collection('Paramedics')
            .where('In_Ambulance.Ambulance_Id', isEqualTo: event.id)
            .get()
            .then((value) {
          database
              .collection('Ambulances')
              .doc(event.id)
              .update({'Status': 'Unoccupied'});
          for (var doc in value.docs) {
            database
                .collection('Paramedics')
                .doc(doc.id)
                .update({'In_Ambulance': {}});
          }
        });
      } else {
        for (var paramedic in paramedics) {
          if (kDebugMode) {
            print(paramedics
                .contains(paramedic['User_ID'] = _paramedicData!.userID));
          }
          if (paramedics
              .contains(paramedic['User_ID'] == _paramedicData!.userID)) {
            await database
                .collection('Paramedics')
                .doc(_paramedicData!.userID)
                .update({'In_Ambulance': {}});
          }
          await database
              .collection('Paramedics')
              .doc(paramedic['User_ID'])
              .update({'In_Ambulance': event.data()});
        }
      }
    });
  }

  Future<String> closeTicket(int level) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = "Finalising ticket...";
    notifyListeners();
    try {
      await database
          .collection('Ambulances')
          .doc(_paramedicData!.inAmbulance!.ambulanceId!)
          .update({'Status': 'Available'}).then((value) async {
        await database
            .collection('Tickets')
            .doc(_dispatchTicket!.ticketId)
            .update({
          'Status': 'Closed',
          'Emergency_Level': level,
          'Closed_At': Timestamp.now(),
        });
      }).then((value) {
        _dispatchTicket = null;
      });
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return state;
  }

  Future<String> leaveAmbulance() async {
    String ambulanceID = _paramedicData!.inAmbulance!.ambulanceId!;
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Dropping you off...';
    notifyListeners();
    try {
      // await database
      //     .collection('Ambulance')
      //     .doc(ambulanceID)
      //     .get()
      //     .then((value) {
      //   var paramedicsList = value.data()!['Paramedics'];
      //   for(var paramedic in paramedicsList){
      //     if(paramedic['User_ID']==_paramedicData!.userID){
      //       await database.collection('Ambulance').doc(ambulanceID).update({
      //         'Paramedics':FieldValue.arrayRemove({
      //           "ddd":
      //         })
      //       });
      //     }
      //   }
      // });
      await database.collection('Ambulances').doc(ambulanceID).update({
        'Paramedics': FieldValue.arrayRemove([
          _paramedicData!.toJson(),
        ])
      });
      // await database
      //     .collection('Paramedic')
      //     .doc(_paramedicData!.userID)
      //     .update({
      //   'In_Ambulance': {},
      // }).then((value) async {
      //   await database
      //       .collection('Ambulance')
      //       .doc(ambulanceID)
      //       .update({'Paramedics': []}).onError((error, stackTrace) => null);
      // });
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return state;
  }

  Future<String> driveAmbulance(Ambulance ambulance) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Assigning vehicle...';
    notifyListeners();
    try {
      var query = database
          .collection('Ambulances')
          .where('Number_Plate', isEqualTo: ambulance.numberPlate);
      //====Go to database and get the Ambulance info======
      query.get().then((ambulanceDoc) async {
        //====When you have found the ambulance data in the database=======
        //====Listen to any change to its data=====

        await database
            .collection('Ambulances')
            .doc(ambulanceDoc.docs[0].id)
            .update(
          {
            'Paramedics': FieldValue.arrayUnion([_paramedicData!.toJson()]),
            'Status': 'Available'
          },
        ).then((value) async {
          trackAmbulanceDataChanges(ambulanceDoc);
        });
      });
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return state;
  }

  Future<LocationData?> getParamedicLocation() async {
    _showprogress = true;
    _userprogresstext = 'Setting location...';
    notifyListeners();

    _serviceEnabled = await _loc.serviceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled');
    } else {
      PermissionStatus permissionStatus = await _loc.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _loc.requestPermission();
        if (permissionStatus == PermissionStatus.denied ||
            permissionStatus == PermissionStatus.deniedForever) {
          _showprogress = false;
          return null;
        } else {
          await _loc.getLocation().then((data) {
            _userLocation = data;
          });
        }
      } else if (permissionStatus == PermissionStatus.granted) {
        await _loc.getLocation().then((data) {
          _userLocation = data;
        });
      }
    }

    _showprogress = false;
    notifyListeners();

    return _userLocation;
  }

  Future<Paramedic?> getCurrentParamedicData(String userID) async {
    _showprogress = true;
    _userprogresstext = 'Setting up profile...';
    notifyListeners();
    final docRef = database.collection("Paramedics").doc(userID);

    try {
      await docRef.get().then(
        (DocumentSnapshot doc) {
          _paramedicData =
              Paramedic.fromJson(doc.data() as Map<String, dynamic>);
          trackParamedicDataChanges();
        },
      );
      if (_paramedicData!.userID == null) {
        await docRef.set(
          {'User_ID': userID},
          SetOptions(merge: true),
        ).onError((error, stackTrace) {});
      }
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return _paramedicData;
  }
}
