import 'package:flutter/material.dart';
import 'package:my_headspace/features/auth/data/models/user_data_model.dart';

import 'package:my_headspace/features/auth/application/enums/user_gender_enum.dart';

class CreateAccountProvider extends ChangeNotifier {
  UserData userData = UserData.empty();

  void setUser(UserData data) {
    userData = data;
    notifyListeners();
  }

  bool get isEmpty  => userData == UserData.empty();

  void updateUserData({
    String? username,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    UserGender? gender,
    String? phone,
  }) {
    userData = userData.copyWith(
      username: username,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      phone: phone,
    );
    notifyListeners();
  }
}
