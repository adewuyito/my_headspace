import 'package:flutter_test/flutter_test.dart';
import 'package:my_headspace/features/auth/application/enums/user_gender_enum.dart';

void main() {
  group("User Gender functions", () {
    test("Parse Gender", () {
      final gender = UserGender.female;

      final parsedGender = UserGender.parseGender("female");

      expect(gender, parsedGender);
    });
  });
}
