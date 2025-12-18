
import 'package:my_headspace/features/auth/application/enums/user_gender_enum.dart';

class CreateUserData {
  final String username;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final UserGender? gender;
  final String phone;

  CreateUserData({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
  });

  CreateUserData copyWith({
    String? username,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    UserGender? gender,
    String? phone,
  }) {
    return CreateUserData(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
    );
  }

  factory CreateUserData.empty() {
    return CreateUserData(
      username: '',
      firstName: '',
      lastName: '',
      dateOfBirth: null,
      gender: null,
      phone: '',
    );
  }
}
