import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String ticketId;
  final String userId;
  final GeoPoint pickUpLocation;
  final String description;
  final int? emergencyLevel;
  final Map? dispatchedAmbulance;
  final Timestamp bookedAt;
  final Timestamp? closedAt;
  final String status;
  final String? managedBy;

  Ticket({
    required this.ticketId,
    required this.userId,
    required this.pickUpLocation,
    required this.description,
    this.emergencyLevel,
    this.dispatchedAmbulance,
    required this.bookedAt,
    this.closedAt,
    required this.status,
    this.managedBy,
  });

  Map<String, Object?> toJson() {
    return {
      'Ticket_Id': ticketId,
      'Emergency_Level': emergencyLevel,
      'User_Id': userId,
      'PickUp_Location': pickUpLocation,
      'Description': description,
      'Dispatched_Ambulance': dispatchedAmbulance,
      'Booked_At': bookedAt,
      'Closed_At': closedAt,
      'Status': status,
      'Managed_By': managedBy,
    };
  }

  static Ticket fromJson(Map<dynamic, dynamic>? json) {
    return Ticket(
      bookedAt: json!['Booked_At'] as Timestamp,
      description: json['Description'] as String,
      pickUpLocation: json['PickUp_Location'] as GeoPoint,
      status: json['Status'] as String,
      ticketId: json['Ticket_Id'] as String,
      userId: json['User_Id'] as String,
      dispatchedAmbulance: json['Dispatched_Ambulance'] as Map?,
      closedAt: json['Closed_At'] as Timestamp?,
      managedBy: json['Managed_By'] as String?,
      emergencyLevel: json['Emergency_Level'] as int?,
    );
  }
}
