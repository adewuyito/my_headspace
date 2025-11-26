import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

class RichTwoPartText extends StatelessWidget {
  final String firstPart;
  final String secondPart;
  const RichTwoPartText({
    super.key,
    required this.firstPart,
    required this.secondPart,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstPart,
            style: hpStyles.r14.copyWith(color: ColorName.textNegative),
          ),
          TextSpan(
            text: ' $secondPart',
            style: hpStyles.sb14.copyWith(color: ColorName.appOrange),
          ),
        ],
      ),
    );
  }
}
