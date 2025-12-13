import 'package:auto_route/auto_route.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:my_headspace/service/service_locator.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authProvider = serviceLocator.getIt<AuthProvider>();

    if (authProvider.isAuthenticated) {
      resolver.next();
      return;
    }

    router.push(GetStartedRoute());
  }
}
