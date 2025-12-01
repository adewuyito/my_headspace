import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/spacing.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';

@routePage
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: CircleAvatar(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Good morning ⛅️", style: hpStyles.r14),
            Text("Emmanual", style: hpStyles.m15),
          ],
        ),
      ),
      body: Padding(
        padding: AppPadding.scaffoldSpacing,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(23, 21, 23, 18),
                width: 345.w,
                height: 328.h,
                decoration: BoxDecoration(
                  color: ColorName.appOrange,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Prophecy of the day",
                      style: hpStyles.sb15.copyWith(
                        color: ColorName.textPositive,
                      ),
                    ),
                    Text(
                      "“Amos 3:3  can two work together except they agree or, except they have agreed”",
                      style: hpStyles.sb25.copyWith(
                        color: ColorName.textPositive,
                      ),
                    ),

                    // ~ Card Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Assets.icons.likeIcon.svg(),
                        Assets.icons.heartIcon.svg(),
                        Assets.icons.shareIcon.svg(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
