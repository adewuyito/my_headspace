import 'package:my_headspace/service/service_locator.dart';

import 'app_route_guard.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'app_route.gr.dart';

/* 
 Flow: 
 ! Onboarding -> Get-started -> CreatAccount -> Login -> Home 
*/

class TransitionsBuilder {
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    /// you get an animation object and a widget
    /// make your own transition
    return FadeTransition(opacity: animation, child: child);
  }
}

@AutoRouterConfig(replaceInRouteName: 'Page|View|Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.authGuard});
  AuthGuard authGuard;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),

    // ~ Home View
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: PersonalisationRoute.page),

    AutoRoute(
      page: ApplicationNavigatorRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: ProfileVeiw.page),
      ],
    ),

    // ~ Permission View
    AutoRoute(page: NotificationPermissonRoute.page),
    AutoRoute(page: BiometricPermissonRoute.page),

    // ~ Utility View
    AutoRoute(page: VerifyMailRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),

    // ~ Login View
    AutoRoute(page: LoginRoute.page),

    // ~ Create Account View
    AutoRoute(
      page: SignupTabviewRoute.page,
      children: [
        AutoRoute(page: CreateAccountRoute1.page),
        AutoRoute(page: CreateAccountRoute2.page),
      ],
    ),

    AutoRoute(page: RegistrationSuccessfulRoute.page),

    AutoRoute(page: GetStartedRoute.page),

    // ~ Onboarding PageView
    AutoRoute(
      page: OnboardingTabviewRoute.page,
      children: [
        AutoRoute(page: OnboardingFirstTabRoute.page),
        AutoRoute(page: OnboardingSecondTabRoute.page),
        AutoRoute(page: OnboardingThirdTabRoute.page),
      ],
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];

  void updateAuthGuard(AuthGuard guard) {
    authGuard = guard;
    notifyListeners();
  }

  // CustomRoute routeWithFadeTransition({
  //   required PageInfo<dynamic> page,
  //   bool initial = false,
  //   String? path,
  //   Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
  //       transitionsBuilder =
  //       TransitionsBuilders.fadeIn,
  //   List<AutoRoute>? children,
  // }) {
  //   return CustomRoute(
  //     path: path,
  //     page: page,
  //     initial: initial,
  //     transitionsBuilder: transitionsBuilder,
  //     durationInMilliseconds: 400,
  //     guards: [authGuard],
  //     children: children,
  //   );
  // }
}
