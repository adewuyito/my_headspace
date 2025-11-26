import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/shared/components/rich_text/base_text.dart';
import 'package:my_headspace/shared/components/rich_text/link_text.dart';

class RichTextWidget extends StatelessWidget {
  final Iterable<BaseText> texts;
  final TextStyle? styleForAll;
  final TextAlign? textAlign;

  const RichTextWidget({
    super.key,
    this.textAlign,
    required this.texts,
    this.styleForAll,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: texts.map((baseText) {
          /// Check for of the returned is a [LinkText] or a normal [BaseText]
          if (baseText is LinkText) {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
              recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
            );
          } else {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
            );
          }
        }).toList(),
      ),
    );
  }
}
