import 'package:firebase_core/firebase_core.dart';
import 'package:my_headspace/features/auth/application/providers/auth_flow_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';
import 'package:my_headspace/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/app.dart';
import 'package:my_headspace/features/home/application/providers/personalisation_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:my_headspace/routes/app_route_guard.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator.configure();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => serviceLocator.getIt<PersonalisationProvider>(),
        ),

        Provider(create: (_) => serviceLocator.getIt<AuthRepository>()),

        Provider(create: (_) => serviceLocator.getIt<AuthGuard>()),

        ChangeNotifierProvider(
          create: (_) => serviceLocator.getIt<AuthProvider>(),
        ),

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
      ],
      child: const MainApp(),
    ),
  );
}
