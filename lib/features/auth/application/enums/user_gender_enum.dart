enum UserGender {
  male,
  female;

  static UserGender? parseGender(String? value) {
    if (value == null) return null;
    return UserGender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserGender.male,
    );
  }
}
