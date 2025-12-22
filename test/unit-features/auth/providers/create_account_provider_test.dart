import 'package:flutter_test/flutter_test.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/features/auth/data/models/user_data_model.dart';

void main() {
  late CreateAccountProvider provider;

  setUp(() {
    provider = CreateAccountProvider();
  });

  group('Check initial state', () {
    test("Check init state is empty", () {
      expect(provider.userData.firstName, '');
      expect(provider.userData.lastName, '');
      expect(provider.userData.username, '');
      expect(provider.userData.dateOfBirth, null);
      expect(provider.userData.gender, null);
      expect(provider.userData.phone, '');
      expect(provider.userData, UserData.empty());
    });
  });

  group("Check provider setters", () {
    test("Set user data field to a valie", () {
      bool notified = false;
      final String username = "adewuyito";
      
      provider.addListener(() => notified = true);
      provider.updateUserData(username: username);

      expect(provider.userData.username, username);
      expect(notified, true);
    });

    test("Check data getter", () {
      bool notified = false;
      final String username = "adewuyito";

      provider.addListener(() => notified = true);
      provider.updateUserData(username: username);

      expect(provider.isEmpty, false);
      expect(notified, true);
    });
  });
}
