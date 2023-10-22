import 'package:ambulance_dispatch_application/Models/ambulance.dart';

class Paramedic {
  final String? userID;
  final String names;
  final String surname;
  final String idNumber;
  final String emailaddress;
  final String role;
  final String cellphoneNumber;
  final Ambulance? inAmbulance;

  Paramedic({
    this.userID,
    required this.inAmbulance,
    required this.names,
    required this.surname,
    required this.idNumber,
    required this.emailaddress,
    required this.role,
    required this.cellphoneNumber,
  });

  Map<String, Object?> toJson() => {
        'User_ID': userID,
        'Names': names,
        'Surname': surname,
        'ID_Number': idNumber,
        'Email_Address': emailaddress,
        'Role': role,
        'Phone_Number': cellphoneNumber,
        'In_Ambulance': inAmbulance != null ? inAmbulance!.toJson() : {},
      };

  static Paramedic fromJson(Map<dynamic, dynamic>? json) => Paramedic(
        userID: json!['User_ID'] as String?,
        cellphoneNumber: json['Phone_Number'] as String,
        emailaddress: json['Email_Address'] as String,
        role: json['Role'] as String,
        idNumber: json['ID_Number'] as String,
        names: json['Names'] as String,
        surname: json['Surname'] as String,
        inAmbulance: json['In_Ambulance'].isNotEmpty
            ? Ambulance.fromJson(
                json['In_Ambulance'] as Map,
              )
            : null,
      );
}
