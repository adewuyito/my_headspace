import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';

class TimeSelectionWiget extends StatelessWidget {
  final String label;
  final VoidCallback onDateSelect;
  final Widget child;

  const TimeSelectionWiget({
    super.key,
    required this.label,
    required this.onDateSelect,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: hpStyles.m14),
        GestureDetector(
          onTap: onDateSelect,

          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
            width: 105.w,
            height: 26.h,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [child, Assets.icons.timerIcon.svg()],
            ),
          ),
        ),
      ],
    );
  }
}
