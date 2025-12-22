import 'package:get_it/get_it.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';
import 'package:my_headspace/features/home/application/providers/personalisation_provider.dart';
import 'package:my_headspace/routes/app_route_guard.dart';

class ServiceLocator {
  final _getit = GetIt.instance;

  GetIt get getIt => _getit;

  void configure() {
    // _getit.registerSingleton<My_Provider>(My_Provider());

    _getit.registerLazySingleton<CreateAccountProvider>(() => CreateAccountProvider());

    _getit.registerSingleton<AuthGuard>(AuthGuard());

    // ~ Ripositories
    _getit.registerLazySingleton<AuthRepository>(() => AuthRepository());

    _getit.registerSingleton<AuthProvider>(AuthProvider());

    _getit.registerLazySingleton<PersonalisationProvider>(
      () => PersonalisationProvider(),
    );
  }
}

final serviceLocator = ServiceLocator();
