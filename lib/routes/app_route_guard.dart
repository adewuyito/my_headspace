
import 'package:auto_route/auto_route.dart';


class AuthGuard extends AutoRouteGuard {
  // AuthGuard(this.authState);
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next();
  }
}
