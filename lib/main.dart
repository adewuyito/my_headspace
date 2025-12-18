import 'package:firebase_core/firebase_core.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  serviceLocator.configure();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateAccountProvider()),

        ChangeNotifierProvider(
          create: (_) => serviceLocator.getIt<PersonalisationProvider>(),
        ),

        Provider(create: (_) => serviceLocator.getIt<AuthRepository>()),

        Provider(create: (_) => serviceLocator.getIt<AuthGuard>()),

        ChangeNotifierProvider(
          create: (_) => serviceLocator.getIt<AuthProvider>(),
        ),

        ChangeNotifierProvider<AppRouter>(create: (_) => AppRouter()),
      ],
      child: const MainApp(),
    ),
  );
}
