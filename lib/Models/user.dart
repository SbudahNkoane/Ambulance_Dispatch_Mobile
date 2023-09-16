class User {
  final String names;
  final String surname;
  final String idNumber;
  final String emailaddress;
  final String gender;
  final String cellphoneNumber;

  User({
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
        'ID Number': idNumber,
        'Email Address': emailaddress,
        'Gender': gender,
        'Phone Number': cellphoneNumber,
      };

  static User fromJson(Map<dynamic, dynamic>? json) => User(
        cellphoneNumber: json!['Phone Number'] as String,
        emailaddress: json['Email Address'] as String,
        gender: json['Gender'] as String,
        idNumber: json['ID number'] as String,
        names: json['Names'] as String,
        surname: json['Surname'] as String,
      );
}
