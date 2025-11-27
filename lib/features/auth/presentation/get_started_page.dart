import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:my_headspace/shared/components/rich_text/base_text.dart';
import 'package:my_headspace/shared/components/rich_text/rich_text_widget.dart';

@routePage
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

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

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0) +
                const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Receive daily guidance and deepen your connection to faith.",
                  style: hpStyles.m16.copyWith(color: ColorName.textPositive),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 80),

                SizedBox(
                  width: 253,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorName.appOrange,
                      elevation: 1,
                    ),
                    onPressed: () {
                      AppNavigator.of(context).push(CreateAccountRoute1());
                    },
                    child: Text("Get Started"),
                  ),
                ),

                const SizedBox(height: 23),

                RichTextWidget(
                  styleForAll: hpStyles.r14,
                  texts: [
                    BaseText.plain(
                      text: "Already have an account? ",
                      style: hpStyles.r14.copyWith(
                        color: ColorName.textPositive,
                      ),
                    ),
                    BaseText.link(
                      onTapped: () {},
                      text: "Log in",
                      style: hpStyles.m14.copyWith(color: ColorName.appOrange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
