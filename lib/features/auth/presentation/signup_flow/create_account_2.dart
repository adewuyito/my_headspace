// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/core/utils/input_validator.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:my_headspace/shared/widgets/shared_textfield.dart';
import 'package:my_headspace/shared/widgets/toc_pp.dart';
import 'package:provider/provider.dart';

@routePage
class CreateAccountPage2 extends HookWidget {
  const CreateAccountPage2({super.key});

  @override
  Widget build(BuildContext context) {
    // ~ Page Controller
    final emailController = useTextEditingController();
    final usernameNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final repasswordController = useTextEditingController();

    final _isLoading = context.watch<AuthProvider>().isLoading;

    final _formKey = GlobalKey<FormState>();

    // ~Provider
    final createAccountProvider = context.read<CreateAccountProvider>();

    Future<void> _createUser() async {
      if (!(_formKey.currentState!.validate())) return;

      // ~ Updated user data
      createAccountProvider.updateUserData(
        username: usernameNameController.text.trim(),
      );

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.signupUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      // TODO!: Save user data on success to firestore

      if (!context.mounted) return;

      if (success) {
        context.router.replaceAll([const ApplicationNavigatorRoute()]);

        // TODO!: Move through the permissions view if never done
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          // TODO: Use snackbar util
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
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
                  key: _formKey,
                  child: Column(
                    spacing: 29,
                    children: [
                      FromTextInputField(
                        controller: usernameNameController,
                        label: "Username",
                        validator: InputValidatorUtils.isUsernameValid,
                      ),

                      FromTextInputField(
                        controller: emailController,
                        label: "Email address",
                        validator: InputValidatorUtils.validEmailAddress,
                      ),

                      FromTextInputField(
                        validateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        label: "Password",
                        validator: (v) =>
                            InputValidatorUtils.nonEmptyField("Password", v),
                      ),

                      FromTextInputField(
                        validateMode: AutovalidateMode.onUserInteraction,
                        controller: repasswordController,
                        label: "Confirm Password",
                        validator: (value) =>
                            InputValidatorUtils.confirmPassword(
                              value!,
                              passwordController.text,
                            ) ??
                            InputValidatorUtils.nonEmptyField(
                              "Password",
                              value,
                            ),
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
              onPressed: _isLoading ? null : _createUser,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text("Agree and continue"),
            ),
          ],
        ),
      ),
    );
  }
}
