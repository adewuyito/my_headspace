import 'package:flutter/material.dart';

// styles
final hpStyles = _AppStyles();

class _AppStyles {
  // height / font size

  //  ~ Light Style
  final l10 = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1.5,
    fontVariations: [FontVariation('wght', 300)],
  );

  final l13 = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    height: 1.15,
    fontVariations: [FontVariation('wght', 300)],
  );

  final l15 = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    height: 1.3,
    fontVariations: [FontVariation('wght', 300)],
  );

  //  ~ Regular Style
  final r13 = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontVariations: [FontVariation('wght', 400)],
  );

  final r14 = const TextStyle(
    fontSize: 14,
    // fontWeight: FontWeight.w400,
    height: 1.45,
    fontVariations: [FontVariation('wght', 400)],
  );

  final r15 = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.67,
    fontVariations: [FontVariation('wght', 400)],
  );

  //  ~ Medium Style
  final m11 = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m13 = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.15,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m15 = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.67,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m14 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.78,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m16 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.47,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m17 = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.47,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m20 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.5,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m25 = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontVariations: [FontVariation('wght', 500)],
  );

  final m35 = const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w500,
    height: 1,
    fontVariations: [FontVariation('wght', 500)],
  );

  // ~ Semi bold
  final sb14 = const TextStyle(
    fontSize: 14,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );

  final sb15 = const TextStyle(
    fontSize: 15,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );


  final sb16 = const TextStyle(
    fontSize: 16,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );

  final sb20 = const TextStyle(
    fontSize: 20,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );

  final sb24 = const TextStyle(
    fontSize: 24,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );

  final sb22 = const TextStyle(
    fontSize: 22,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );

  final sb25 = const TextStyle(
    fontSize: 25,
    height: 1.45,
    fontVariations: [FontVariation('wght', 600)],
  );


  //  ~ Bold Style
  final b9 = const TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    height: 2.2,
    fontVariations: [FontVariation('wght', 700)],
  );

  final b16 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.45,
    fontVariations: [FontVariation('wght', 700)],
  );

  final b26 = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: .9,
    fontVariations: [FontVariation('wght', 700)],
  );

  // final gradientStyle = TextStyle(
  //   foreground: Paint()
  //     ..shader = const LinearGradient(
  //       colors: [
  //         Color(0xFF7205F8),
  //         Color(0xFFED36E1),
  //       ],
  //     ).createShader(
  //       const Rect.fromLTWH(0, 0, 300, 0),
  //     ),
  // );
}
