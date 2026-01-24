import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

class JourneyDateDivider extends StatelessWidget {
  final String date;
  const JourneyDateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 23),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: ColorName.dateDividerBackground,
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Text(date, style: hpStyles.m9,), // TODO: Fix Data
      ),
    );
  }
}
