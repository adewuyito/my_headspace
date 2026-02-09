import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';

class EditorHeadingTextfield extends StatelessWidget {
  final bool autofocus;
  final TextEditingController controller;
  const EditorHeadingTextfield(
    this.autofocus, {
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    autofocus: autofocus,
    style: hpStyles.sb16,

    decoration: InputDecoration(
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      hintText: 'Start with a title',
      hintStyle: hpStyles.m16,
    ),
  );
}
