import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

class FromTextInputField extends StatelessWidget {
  const FromTextInputField({
    super.key,
    required this.controller,
    this.label = "",
    this.validator,
    this.validateMode,
  });

  final TextEditingController controller;
  final String? label;
  final Validator validator;
  final AutovalidateMode? validateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: validateMode,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hint: Text(
          label ?? "",
          style: hpStyles.r14.copyWith(color: ColorName.textGrayB3),
        ),
      ),
    );
  }
}

typedef Validator = String? Function(String?)?;
