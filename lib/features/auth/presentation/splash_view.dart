import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';

@routePage
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    final buildContext = context;

    () async {
      await Future.delayed(Duration(seconds: 2));

      if (!buildContext.mounted) return;

      AppNavigator.of(buildContext).replace(ApplicationNavigatorRoute());
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ColorName.appGreen2);
  }
}
