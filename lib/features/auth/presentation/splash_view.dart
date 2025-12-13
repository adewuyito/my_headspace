import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:provider/provider.dart';

@routePage
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isAuthenticated && !authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.isAuthenticated) {
      context.router.replace(const HomeRoute());
    } else {
      context.router.replace(GetStartedRoute());
    }

    return const SizedBox.shrink();
  }
}
