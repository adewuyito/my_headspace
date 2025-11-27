import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/shared/components/rich_text/base_text.dart';
import 'package:my_headspace/shared/components/rich_text/rich_text_widget.dart';
import 'package:my_headspace/shared/widgets/toc_pp.dart';

@routePage
class VerifyMailPage extends StatelessWidget {
  const VerifyMailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Log in",
              style: hpStyles.b16.copyWith(color: ColorName.appOrange),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 38.0) +
            const EdgeInsets.only(top: 10, bottom: 26),

        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 29,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Verify Email", style: hpStyles.sb24),
                Text(
                  "We sent a verification link to your email. Please on it to complete your account registration. ",
                  style: hpStyles.r14.copyWith(color: ColorName.textGray78),
                ),
              ],
            ),

            SizedBox(height: 52.h),

            RichTextWidget(
              styleForAll: hpStyles.r14,
              texts: [
                BaseText.plain(
                  text: "Didn't receive code?  ",
                  style: hpStyles.r14.copyWith(color: ColorName.textNegative),
                ),
                BaseText.link(
                  onTapped: () {},
                  text: "Resend link",
                  style: hpStyles.m14.copyWith(color: ColorName.appOrange),
                ),
              ],
            ),

            Spacer(),

            TocPp(),

            const SizedBox(height: 35),

            ElevatedButton(onPressed: () {}, child: Text("Complete")),
          ],
        ),
      ),
    );
  }
}
