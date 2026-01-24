import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

class JourneyCard extends StatelessWidget {
  final String heading;
  final String body;
  const JourneyCard({super.key, required this.heading, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(Size(384.w, 109.h)),
      padding: EdgeInsets.fromLTRB(24, 17, 24, 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ), // TODO: DO the color logic thing
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(heading, style: hpStyles.sb20,),
          Expanded(child: Text(body, softWrap: true, maxLines: 3, style: hpStyles.r13.copyWith(
            color: ColorName.textGray7D
          ),)),
        ],
      ),
    );
  }
}
