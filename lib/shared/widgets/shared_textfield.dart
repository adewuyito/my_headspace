import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

class FromTextInputField extends StatelessWidget {
  const FromTextInputField({
    super.key,
    required this.controller,
    this.label = "",
  });

  final TextEditingController controller;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hint: Text(
          label ?? "",
          style: hpStyles.r14.copyWith(color: ColorName.textGrayB3),
        ),
      ),
    );
  }
}
