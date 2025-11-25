import 'package:flutter/material.dart';
import 'package:my_headspace/app.dart';
import 'package:my_headspace/features/auth/data/auth_provider.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:my_headspace/routes/app_route_guard.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  serviceLocator.configure();

  runApp(
    MultiProvider(
      providers: [
        //
        Provider(create: (context) => serviceLocator.getIt<AuthGuard>()),

        ChangeNotifierProxyProvider<AuthGuard, AppRouter>(
          create: (context) {
            final guard = Provider.of<AuthGuard>(context, listen: false);
            return AppRouter(authGuard: guard);
          },
          update: (cxt, guard, router) {
            if (router != null) {
              router.updateAuthGuard(guard);
              return router;
            }
            return AppRouter(authGuard: guard);
          },
        ),

        ChangeNotifierProvider(
          create: (context) => serviceLocator.getIt<AuthProvider>(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
