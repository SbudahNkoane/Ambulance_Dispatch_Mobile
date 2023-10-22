import 'package:cloud_firestore/cloud_firestore.dart';

class Ambulance {
  final String? ambulanceId;
  final String numberPlate;
  final List<dynamic>? paramedics;
  final String managedBy;
  final String status;
  final GeoPoint realTimeLocation;
  Ambulance({
    required this.status,
    this.paramedics,
    required this.ambulanceId,
    required this.numberPlate,
    required this.managedBy,
    required this.realTimeLocation,
  });
  Map<String, Object?> toJson() => {
        'Ambulance_Id': ambulanceId,
        'Paramedics': paramedics,
        'Status': status,
        'Number_Plate': numberPlate,
        'Managed_By': managedBy,
        'RealTime_Location': realTimeLocation,
      };

  static Ambulance fromJson(Map<dynamic, dynamic>? json) => Ambulance(
        ambulanceId: json!['Ambulance_Id'] as String?,
        numberPlate: json['Number_Plate'] as String,
        managedBy: json['Managed_By'] as String,
        paramedics: json['Paramedics'] as List<dynamic>?,
        realTimeLocation: json['RealTime_Location'] as GeoPoint,
        status: json['Status'] as String,
      );
}
