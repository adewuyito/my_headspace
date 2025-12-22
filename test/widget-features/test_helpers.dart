import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:provider/provider.dart'; // or your state management

Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  AuthProvider? authProvider,
}) async {
  final router = AppRouter();

  await tester.pumpWidget(
    MultiProvider(
      // or MultiProvider
      providers: [
        if (authProvider != null)
          ChangeNotifierProvider.value(value: authProvider),
      ],
      child: MaterialApp.router(
        routerConfig: router.config(),
      ),
    ),
  );
}
