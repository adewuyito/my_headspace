import 'package:get_it/get_it.dart';
import 'package:my_headspace/features/auth/application/providers/login_provider.dart';
import 'package:my_headspace/features/auth/application/providers/reset_password_provider.dart';
import 'package:my_headspace/features/auth/application/providers/signup_provider.dart';
import 'package:my_headspace/features/auth/data/auth_provider.dart';
import 'package:my_headspace/routes/app_route_guard.dart';

class ServiceLocator {
  final _getit = GetIt.instance;

  GetIt get getIt => _getit;

  void configure() {
    // _getit.registerSingleton<My_Provider>(My_Provider());

    _getit.registerSingleton<AuthGuard>(AuthGuard());
    _getit.registerSingleton<AuthProvider>(AuthProvider());

    _getit.registerFactory<ResetPasswordProvider>(() => ResetPasswordProvider());
    
    _getit.registerLazySingleton<SignupProvider>(() => SignupProvider());
    _getit.registerLazySingleton<LoginProvider>(() => LoginProvider());
  }
}

final serviceLocator = ServiceLocator();
