import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart'
    as app_auth;
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:provider/provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCreateAccountProvider extends Mock implements CreateAccountProvider {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late app_auth.AuthProvider authProvider;
  late MockAuthRepository mockAuthRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockCreateAccountProvider mockcreateAccountProvider;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockFirebaseAuth = MockFirebaseAuth();
    mockcreateAccountProvider = MockCreateAccountProvider();

    when(
      () => mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream.empty());

    authProvider = app_auth.AuthProvider(
      authRepo: mockAuthRepository,
      userDataProvider: mockcreateAccountProvider,
      firebaseAuth: mockFirebaseAuth,
    );

    if (GetIt.I.isRegistered<app_auth.AuthProvider>()) {
      GetIt.I.unregister<app_auth.AuthProvider>();
    }
    GetIt.I.registerSingleton<app_auth.AuthProvider>(authProvider);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('shows email and password fields and login button', (
      tester,
    ) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        ChangeNotifierProvider<app_auth.AuthProvider>.value(
          value: authProvider,
          child: MaterialApp.router(routerConfig: appRouter.config()),
        ),
      );

      appRouter.push(const LoginRoute());
      await tester.pump();

      final emailField = find.text('Email address');
      final passwordField = find.text('Password');

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Next'), findsOneWidget);
      expect(
        find.widgetWithText(TextButton, 'Forgot password?'),
        findsOneWidget,
      );
    });

    testWidgets('shows email field validations', (WidgetTester tester) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        ChangeNotifierProvider<app_auth.AuthProvider>.value(
          value: authProvider,
          child: MaterialApp.router(routerConfig: appRouter.config()),
        ),
      );

      appRouter.push(const LoginRoute());
      await tester.pump();

      // ~ Assert validation field on empty text field
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);

      // ~ Assert validation field on invalid text field
      final emailField = find.widgetWithText(TextFormField, 'Email address');

      await tester.enterText(emailField, 'test');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Invalid email address'), findsOneWidget);

      // ~ Assert validation field on valid text field
      await tester.enterText(emailField, 'test@example.com');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Invalid email address'), findsNothing);
    });

    testWidgets('shows loading indicator inside button when isLoading is true', (
      tester,
    ) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        ChangeNotifierProvider<app_auth.AuthProvider>.value(
          value: authProvider,
          child: MaterialApp.router(routerConfig: appRouter.config()),
        ),
      );

      appRouter.push(const LoginRoute());
      await tester.pumpAndSettle();

      when(
        () => mockAuthRepository.loginUserWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        final user = MockUser();
        when(() => user.uid).thenReturn('test_uid');
        return user;
      });

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      await tester.tap(find.byType(ElevatedButton));

      // First frame after login is triggered: AuthProvider sets isLoading=true
      // and notifies listeners, so the button should show a loader.
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      // Allow the mocked login call (and internal 100ms delay) to complete,
      // after which AuthProvider sets isLoading=false and rebuilds.
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNothing,
      );
    });

    testWidgets('Forget password button navigates to the correct page', (
      tester,
    ) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        ChangeNotifierProvider<app_auth.AuthProvider>.value(
          value: authProvider,
          child: MaterialApp.router(routerConfig: appRouter.config()),
        ),
      );

      appRouter.push(const LoginRoute());
      await tester.pump();

      final passordButton = find.widgetWithText(TextButton, 'Forgot password?');

      // ~ assert find button on page
      expect(passordButton, findsOneWidget);

      // ~ Tap button and pump
      await tester.tap(passordButton);
      await tester.pumpAndSettle();

      expect(appRouter.current.name, ResetPasswordRoute.name);
    });
  });
}
