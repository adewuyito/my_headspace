import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get_it/get_it.dart';
import 'package:my_headspace/features/auth/application/providers/auth_flow_provider.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';
import 'package:my_headspace/features/home/application/providers/personalisation_provider.dart';
import 'package:my_headspace/routes/app_route_guard.dart';

class ServiceLocator {
  final _getit = GetIt.instance;

  GetIt get getIt => _getit;

  void configure() {
    // _getit.registerSingleton<My_Provider>(My_Provider());

    _getit.registerSingleton<AuthGuard>(AuthGuard());

    // ~ Firebase
    _getit.registerLazySingleton<firebase.FirebaseAuth>(
      () => firebase.FirebaseAuth.instance,
    );

    // ~ Ripositories
    _getit.registerLazySingleton<AuthRepository>(() => AuthRepository());

    _getit.registerLazySingleton<AuthProvider>(() => AuthProvider(getIt()));

    _getit.registerLazySingleton<PersonalisationProvider>(
      () => PersonalisationProvider(),
    );
  }
}

final serviceLocator = ServiceLocator();
