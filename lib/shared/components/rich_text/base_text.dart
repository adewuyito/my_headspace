import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/shared/components/rich_text/link_text.dart';



@immutable
class BaseText {
  final String text;
  final TextStyle? style;

  const BaseText({required this.text, this.style});

  factory BaseText.plain({
    required String text,
    TextStyle? style = const TextStyle(
      color: Color(0xFF667185),
    ),
  }) {
    return BaseText(
      text: text,
      style: style,
    );
  }

  factory BaseText.link({
    required VoidCallback onTapped,
    required String text,
    TextStyle? style = const TextStyle(
      color: ColorName.appOrange,
    ),
  }) {
    return LinkText(
      onTapped: onTapped,
      text: text,
      style: style,
    );
  }
}
