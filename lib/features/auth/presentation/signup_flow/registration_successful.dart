import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';

@routePage
class RegistrationSuccessfulView extends StatelessWidget {
  const RegistrationSuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 38.0) +
            const EdgeInsets.only(top: 10, bottom: 26),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Assets.icons.successCon.svg(),

            SizedBox(height: 0.1.sh),

            Column(
              spacing: 26,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Registration successful 🥳", style: hpStyles.sb22),
                Text(
                  "You have sucessfully complete your account registration",
                  style: hpStyles.r14.copyWith(color: ColorName.textGray78),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            SizedBox(height: 0.35.sh),

            ElevatedButton(
              onPressed: () {
                AppNavigator.of(context).replace(NotificationPermissonRoute());
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
