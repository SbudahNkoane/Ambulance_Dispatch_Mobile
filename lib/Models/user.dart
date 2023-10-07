class User {
  final String? userID;
  final String names;
  final String surname;
  final String idNumber;
  final String emailaddress;
  final String gender;
  final int cellphoneNumber;
  final String accountStatus;
  final String? verifiedBy;
  final String? verificationPicture;
  final String? idDocument;
  final String? profilePicture;
  final String? role;

  User({
    this.userID,
    this.profilePicture,
    this.idDocument,
    this.verificationPicture,
    this.role,
    this.verifiedBy,
    required this.accountStatus,
    required this.names,
    required this.surname,
    required this.idNumber,
    required this.emailaddress,
    required this.gender,
    required this.cellphoneNumber,
  });

  Map<String, Object?> toJson() => {
        'Names': names,
        'Surname': surname,
        'ID_Number': idNumber,
        'Email_Address': emailaddress,
        'Gender': gender,
        'Phone_Number': cellphoneNumber,
        'Verification_Picture': verificationPicture,
        'ID_Document': idDocument,
        'Profile_Picture': profilePicture,
        'Role': role,
      };

  static User fromJson(Map<dynamic, dynamic>? json) => User(
        cellphoneNumber: json!['Phone_Number'] as int,
        emailaddress: json['Email_Address'] as String,
        gender: json['Gender'] as String,
        idNumber: json['ID_Number'] as String,
        names: json['Names'] as String,
        surname: json['Surname'] as String,
        accountStatus: json['Account_Status'] as String,
        verifiedBy: json['Verified_By'] as String?,
        verificationPicture: json['Verification_Picture'] as String?,
        idDocument: json['ID_Document'] as String?,
        role: json['Role'] as String,
        profilePicture: json['Profile_Picture'] as String?,
        userID: json['User_ID'] as String?,
      );
}
