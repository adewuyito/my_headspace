// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:my_headspace/shared/components/rich_text/rich_text_widget.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockCreateAccountProvider extends Mock implements CreateAccountProvider {}

void main() {
  late MockAuthProvider authProvider;
  late CreateAccountProvider createAccountProvider;

  setUp(() {
    authProvider = MockAuthProvider();
    createAccountProvider = MockCreateAccountProvider();
  });

  group('GetStartedPage Widget Tests', () {
    testWidgets('Page load with required navigation button', (tester) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: appRouter.config()),
      );
      await tester.pumpAndSettle();

      expect(appRouter.current.name, GetStartedRoute.name);

      // ~ find get started button
      expect(
        find.widgetWithText(ElevatedButton, 'Get Started'),
        findsOneWidget,
      );

      // ~ find login button
      final loginRichTextWidget = find.byWidgetPredicate(
        (widget) => widget is RichTextWidget,
      );

      expect(loginRichTextWidget, findsOneWidget);
    });

    testWidgets('Page navigation', (tester) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        ChangeNotifierProvider<CreateAccountProvider>.value(
          value: createAccountProvider,
          child: MaterialApp.router(routerConfig: appRouter.config()),
        ),
      );
      await tester.pumpAndSettle();

      expect(appRouter.current.name, GetStartedRoute.name);

      final getStartedButton = find.widgetWithText(
        ElevatedButton,
        'Get Started',
      );

      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      expect(appRouter.current.name, SignupTabviewRoute.name);
    });
  });
}
