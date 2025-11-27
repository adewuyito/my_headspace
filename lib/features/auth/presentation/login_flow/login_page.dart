import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/shared/components/rich_text/base_text.dart';
import 'package:my_headspace/shared/components/rich_text/rich_text_widget.dart';
import 'package:my_headspace/shared/widgets/shared_textfield.dart';

@routePage
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ~ Text Controller
    final _firstName = useTextEditingController();
    final _lastName = useTextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 38.0) +
            const EdgeInsets.only(top: 10, bottom: 26),

        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Log in", style: hpStyles.sb24),
                Text(
                  "Enter your email and password to log in",
                  style: hpStyles.r14.copyWith(color: ColorName.textGray78),
                ),

                const SizedBox(height: 33),

                Form(
                  child: Column(
                    spacing: 29,
                    children: [
                      FromTextInputField(
                        controller: _firstName,
                        label: "Email address",
                      ),
                      FromTextInputField(
                        controller: _lastName,
                        label: "Password",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 33),

            TextButton(
              onPressed: () {},
              child: Text(
                "Forgot password?",
                style: hpStyles.m16.copyWith(color: Color(0xFF1A6B51)),
              ),
            ),

            Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: () {}, child: Text("Next")),
                ),
                const SizedBox(width: 25),
                Assets.icons.fingerprint.svg(),
              ],
            ),

            const SizedBox(height: 21),

            RichTextWidget(
              styleForAll: hpStyles.r14.copyWith(letterSpacing: -.1),
              texts: [
                BaseText.plain(
                  text: "Don’t have an account? ",
                  style: hpStyles.r14.copyWith(color: Color(0xFF667185)),
                ),
                BaseText.link(
                  onTapped: () {},
                  text: "Create account",
                  style: hpStyles.m14.copyWith(color: ColorName.appOrange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
