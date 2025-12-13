import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/routes/app_route.gr.dart';

@RoutePage(name: 'SignupTabviewRoute')
class SignupTabViewPage extends HookWidget {
  const SignupTabViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: [CreateAccountRoute1(), CreateAccountRoute2()],

      builder: (context, child, pageController) {
        return child;
      },
    );
  }
}
