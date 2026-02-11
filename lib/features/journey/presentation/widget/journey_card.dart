import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

class JourneyCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String heading;
  final String body;
  const JourneyCard({
    super.key,
    required this.heading,
    required this.body,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFEECE7), // TODO: DO the color logic thing
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(21.w, 17.h, 21.w, 11.h),
        onTap: onTap,
        title:
            // Hero(
            // tag: 'note-title-',
            // child: Material(
            //   color: Colors.transparent,
            //   child:
            Text(heading, style: hpStyles.sb20),
        // ),
        // ), // TODO: Fix tab
        subtitle:
            // Hero(
            //   tag: 'note-content-',
            //   child: Material(
            //     color: Colors.transparent,
            // child:
            Text(
              // _getNotePreview(index),
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: hpStyles.r13.copyWith(color: ColorName.textGray7D),
            ),
        // ),
        // ),
      ),
    );
  }
}

// child: Padding(
        //   padding: EdgeInsets.fromLTRB(21.w, 17.h, 21.w, 11.h),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       Text(heading, style: hpStyles.sb20),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 5.0, top: 9.0),
        //         child: Text(
        //           body,
        //           softWrap: true,
        //           maxLines: 3,
        //           style: hpStyles.r13.copyWith(color: ColorName.textGray7D),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),


/* 

     Container(
        constraints: BoxConstraints.loose(Size(384.w, 110.h)),
        padding: EdgeInsets.fromLTRB(24.w, 17.h, 24.w, 11.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(heading, style: hpStyles.sb20),
            Expanded(
              child: Text(
                body,
                softWrap: true,
                maxLines: 3,
                style: hpStyles.r13.copyWith(color: ColorName.textGray7D),
              ),
            ),
          ],
        ),
      ),
   

 */