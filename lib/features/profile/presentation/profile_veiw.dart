import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:provider/provider.dart';

@routePage
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 51),

          const SizedBox(height: 18),

          Text("James Emmanuel", style: hpStyles.sb16),

          const SizedBox(height: 33),

          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(17, 0, 12, 0),
                  leading: Assets.icons.editAccountIcon.svg(),
                  trailing: RotatedBox(
                    quarterTurns: 3,
                    child: Assets.icons.caratDown.svg(),
                  ),
                  title: Text("Edit account", style: hpStyles.sb14),
                  subtitle: Text(
                    "Update your account information",
                    style: hpStyles.r12.copyWith(
                      color: Color.fromRGBO(151, 151, 151, 1),
                    ),
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(17, 0, 12, 0),
                  leading: Assets.icons.personalizationIcon.svg(),
                  trailing: RotatedBox(
                    quarterTurns: 3,
                    child: Assets.icons.caratDown.svg(),
                  ),
                  title: Text("Personalization", style: hpStyles.sb14),
                  subtitle: Text(
                    "Update how your notifications are sent",
                    style: hpStyles.r12.copyWith(
                      color: Color.fromRGBO(151, 151, 151, 1),
                    ),
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(17, 0, 12, 0),
                  leading: Assets.icons.privacyIcon.svg(),
                  trailing: RotatedBox(
                    quarterTurns: 3,
                    child: Assets.icons.caratDown.svg(),
                  ),
                  title: Text("Change Password", style: hpStyles.sb14),
                  subtitle: Text(
                    "Update your account password",
                    style: hpStyles.r12.copyWith(
                      color: Color.fromRGBO(151, 151, 151, 1),
                    ),
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(17, 0, 12, 0),
                  leading: Assets.icons.biometricIcon.svg(),
                  title: Text("Biometric login", style: hpStyles.sb14),
                  subtitle: Text(
                    "Enable fingerprint or face ID login",
                    style: hpStyles.r12.copyWith(
                      color: Color.fromRGBO(151, 151, 151, 1),
                    ),
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(17, 0, 12, 0),
                  leading: Assets.icons.signOutIccon.svg(),
                  title: Text("Sign out", style: hpStyles.sb14),
                  subtitle: Text(
                    "Leave the app",
                    style: hpStyles.r12.copyWith(
                      color: Color.fromRGBO(151, 151, 151, 1),
                    ),
                  ),
                  onTap: () async {
                    await context.read<AuthProvider>().logOutUser();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 57),

          Text("App Version 1.0", style: hpStyles.m11),

          const SizedBox(height: 22),

          //  ~ Provacy and Policicies
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "TERMS AND CONDITION",
                  style: hpStyles.sb10.copyWith(color: ColorName.textNegative),
                ),
              ),

              Container(width: 2, height: 16, color: ColorName.backgroundDark),

              TextButton(
                onPressed: () {},
                child: Text(
                  "PRIVACY POLICY",
                  style: hpStyles.sb10.copyWith(color: ColorName.textNegative),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
