import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/app_theme.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = context.read<AppRouter>();
    final authProvider = serviceLocator.getIt<AuthProvider>();

    return ScreenUtilInit(
      designSize: const Size(402, 874),

      child: MaterialApp.router(
        theme: headspaceTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(
          reevaluateListenable: authProvider,
        ),
      ),
    );
  }
}
