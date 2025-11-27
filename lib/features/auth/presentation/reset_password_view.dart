import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/shared/widgets/shared_textfield.dart';

@routePage
class ResetPasswordPage extends HookWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _mail = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Reset password", style: hpStyles.sb20)),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 38.0) +
            const EdgeInsets.only(top: 10, bottom: 26),

        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Let's get you back in", style: hpStyles.sb24),
                Text(
                  "Enter the email address associated with your account and we will send an instruction",
                  style: hpStyles.r14.copyWith(color: ColorName.textGray78),
                ),

                const SizedBox(height: 49),

                Form(
                  child: Column(
                    spacing: 29,
                    children: [
                      FromTextInputField(
                        controller: _mail,
                        label: "Email address",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacer(),

            ElevatedButton(onPressed: () {}, child: Text("Next")),
          ],
        ),
      ),
    );
  }
}
