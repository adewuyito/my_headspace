import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_headspace/features/auth/application/enums/user_gender_enum.dart';

@immutable
class FirebaseCollectionName {
  static const userCollection = 'users';

  const FirebaseCollectionName._();
}

@immutable
class FirebaseFieldName {
  static const displayName = 'display_name';

  static const userId = 'uid';
  static const email = 'email';
  static const firstName = 'first_name';
  static const lastName = 'last_name';
  static const dateOfBirth = 'dateOfBirth';
  static const gender = 'gender';
  static const phone = 'phone';

  const FirebaseFieldName._();
}

class UserData {
  final String username;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final UserGender? gender;
  final String phone;

  UserData({
    required this.username,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    required this.phone,
  });

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseFieldName.displayName: username,
      FirebaseFieldName.firstName: firstName,
      FirebaseFieldName.lastName: lastName,
      FirebaseFieldName.dateOfBirth: dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth!)
          : null,
      FirebaseFieldName.gender: gender?.name,
      FirebaseFieldName.phone: phone,
    };
  }

  factory UserData.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) return UserData.empty();

    return UserData(
      username: data[FirebaseFieldName.displayName] as String? ?? '',
      firstName: data[FirebaseFieldName.firstName] as String? ?? '',
      lastName: data[FirebaseFieldName.lastName] as String? ?? '',
      dateOfBirth: data[FirebaseFieldName.dateOfBirth] is Timestamp
          ? (data[FirebaseFieldName.dateOfBirth] as Timestamp).toDate()
          : null,
      gender: UserGender.parseGender(data[FirebaseFieldName.gender] as String?),
      phone: data[FirebaseFieldName.phone] as String? ?? '',
    );
  }

  UserData copyWith({
    String? username,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    UserGender? gender,
    String? phone,
  }) {
    return UserData(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
    );
  }

  factory UserData.empty() {
    return UserData(
      username: '',
      firstName: '',
      lastName: '',
      dateOfBirth: null,
      gender: null,
      phone: '',
    );
  }

  @override
  String toString() {
    return '''UserData{
                  username: $username,
                  firstName: $firstName,
                  lastName: $lastName,
                  dateOfBirth: $dateOfBirth,
                  gender: $gender,
                  phone: $phone
              }''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          dateOfBirth == other.dateOfBirth &&
          gender == other.gender &&
          phone == other.phone;

  @override
  int get hashCode =>
      Object.hash(username, firstName, lastName, dateOfBirth, gender, phone);
}
