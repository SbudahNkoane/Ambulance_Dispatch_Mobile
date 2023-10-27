import 'package:ambulance_dispatch_application/Models/ambulance.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AmbulanceManager with ChangeNotifier {
  List<Ambulance> _availableAmbulances = [];
  List<Ambulance> get availableAmbulances => _availableAmbulances;
  Future<List<Ambulance>> getAvailableAmbulances() async {
    try {
      final docRef = database.collection("Ambulance").where(
            Filter.or(
              Filter('Status', isEqualTo: 'Available'),
              Filter('Status', isEqualTo: 'Unoccupied'),
            ),
          );
      await docRef.get().then((listOfAmbulances) {
        docRef.snapshots().listen((event) {
          _availableAmbulances = [];
          for (var ambu in event.docs) {
            _availableAmbulances.add(Ambulance.fromJson(ambu.data()));
          }
        });
        _availableAmbulances = [];
        for (var ambulance in listOfAmbulances.docs) {
          _availableAmbulances.add(
            Ambulance.fromJson(
              ambulance.data(),
            ),
          );
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    notifyListeners();
    return _availableAmbulances;
  }
}
