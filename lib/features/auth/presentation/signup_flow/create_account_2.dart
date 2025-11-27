// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/auth/application/providers/signup_provider.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:my_headspace/shared/widgets/shared_textfield.dart';
import 'package:my_headspace/shared/widgets/toc_pp.dart';

@routePage
class CreateAccountPage2 extends HookWidget {
  const CreateAccountPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final signupProvider = serviceLocator.getIt<SignupProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: AutoLeadingButton(),
        actions: [
          TextButton(
            onPressed: () {
              AppNavigator.of(context).push(LoginRoute());
            },
            child: Text(
              "Log in",
              style: hpStyles.b16.copyWith(color: ColorName.appOrange),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 38.0) +
            const EdgeInsets.only(top: 10, bottom: 26),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create your account", style: hpStyles.sb24),
                Text(
                  "Lets get you started with your account",
                  style: hpStyles.r14.copyWith(color: ColorName.textGray78),
                ),

                SizedBox(height: 37.h),

                Center(
                  child: Assets.images.signupImage.image(width: 93, height: 93),
                ),

                SizedBox(height: 23.h),

                Form(
                  child: Column(
                    spacing: 29,
                    children: [
                      FromTextInputField(
                        controller: signupProvider.usernameNameController,
                        label: "Username",
                      ),

                      FromTextInputField(
                        controller: signupProvider.emailController,
                        label: "Email address",
                      ),

                      FromTextInputField(
                        controller: signupProvider.passwordController,
                        label: "Password",
                      ),

                      FromTextInputField(
                        controller: signupProvider.confirmPasswordController,
                        label: "Confirm Password",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),

            TocPp(),

            const SizedBox(height: 35),

            ElevatedButton(
              onPressed: () {
                AppNavigator.of(context).push(VerifyMailRoute());
              },
              child: Text("Agree and continue"),
            ),
          ],
        ),
      ),
    );
  }
}
