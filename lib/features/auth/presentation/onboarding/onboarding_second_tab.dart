import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@routePage
class OnboardingSecondTabPage extends StatelessWidget {
  const OnboardingSecondTabPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7],
                colors: [
                  Color(0xFF0B2F23).withValues(alpha: .2),
                  Color(0xFF0B2F23),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
