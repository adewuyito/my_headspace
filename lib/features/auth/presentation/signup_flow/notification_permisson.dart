import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';

@routePage
class NotificationPermissonPage extends StatelessWidget {
  const NotificationPermissonPage({super.key});

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
            Assets.icons.notificationsIcon.svg(width: 240, height: 240),

            SizedBox(height: 64.h),

            Column(
              children: [
                Column(
                  spacing: 26,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Turn on notifications?", style: hpStyles.sb22),
                    SizedBox(
                      width: 297.w,
                      child: Text(
                        "Enable push notifications so you don’t miss important updates like inspirational quotes and daily prophesies.",
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

            ElevatedButton(onPressed: () {}, child: Text("Next")),

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
