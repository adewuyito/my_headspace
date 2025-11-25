import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/app_theme.dart';
import 'package:my_headspace/routes/app_route.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),

      child: MaterialApp.router(
        theme: headspaceTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: context.select((AppRouter r) => r.config()),
      ),
    );
  }
}

class StatingApp extends StatelessWidget {
  const StatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hello World"));
  }
}
