import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';

@routePage
class BiometricPermissonPage extends StatelessWidget {
  const BiometricPermissonPage({super.key});

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
            Assets.images.biometricImage2.image(width: 195, height: 213),

            SizedBox(height: 64.h),

            Column(
              children: [
                Column(
                  spacing: 26,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Instant and secure login with Touch ID",
                      style: hpStyles.sb22,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 297.w,
                      child: Text(
                        "You can instantly and securely log in to your account using biometric data",
                        style: hpStyles.r14.copyWith(
                          color: ColorName.textGray78,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 0.25.sh),

            ElevatedButton(
              onPressed: () {
                // TODO! get user permission then navigate

                AppNavigator.of(context).push(ApplicationNavigatorRoute());
              },
              child: Text("Next"),
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: () {},
              child: Text(
                "Maybe later",
                style: hpStyles.sb16.copyWith(color: ColorName.appOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
