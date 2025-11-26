// import 'package:flutter/material.dart';
// import 'package:instagram_app_clone/common/components/animations/models/lottie_animations.dart';
// import 'package:lottie/lottie.dart';

// class LottieAnimationWidget extends StatelessWidget {
//   final LottieAnimation animation;
//   final bool repeat;
//   final bool reverse;

//   const LottieAnimationWidget({
//     super.key,
//     required this.animation,
//     this.repeat = true,
//     this.reverse = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Lottie.asset(
//       animation.fullPath,
//       repeat: repeat,
//       reverse: reverse,
//     );
//   }
// }


// // Extentions for LottieAnimation to get animmation asset full path
// extension GetFullPath on LottieAnimation {
//   String get fullPath => 'assets/animations/$name.json';
// }
