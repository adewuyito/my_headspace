import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/shared/components/rich_text/base_text.dart';
import 'package:my_headspace/shared/components/rich_text/rich_text_widget.dart';

class TocPp extends StatelessWidget {
  const TocPp({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      textAlign: TextAlign.center,
      styleForAll: hpStyles.r14.copyWith(letterSpacing: -.01),
      texts: [
        BaseText.plain(
          text: "By continuing to create account, you agree with our ",
        ),
        BaseText.link(
          onTapped: () {},
          text: "Terms of Service",
          style: hpStyles.m14.copyWith(color: ColorName.appOrange),
        ),
        BaseText.plain(text: " and "),
        BaseText.link(
          onTapped: () {},
          text: "Privacy Policy",
          style: hpStyles.m14.copyWith(color: ColorName.appOrange),
        ),
      ],
    );
  }
}
