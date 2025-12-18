// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:date_field/date_field.dart';
import 'package:my_headspace/core/utils/input_validator.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/shared/widgets/shared_textfield.dart';
import 'package:my_headspace/features/auth/application/enums/user_gender_enum.dart';
import 'package:provider/provider.dart';

@routePage
class CreateAccountPage1 extends HookWidget {
  const CreateAccountPage1({super.key});

  @override
  Widget build(BuildContext context) {
    // ~ Text Controller
    final firstnameController = useTextEditingController();
    final lastnameController = useTextEditingController();

    final phoneNumberController = useTextEditingController();
    final userAgeController = useState<DateTime?>(null);
    final userGenderController = useState<UserGender?>(null);

    final _formKey = GlobalKey<FormState>();

    // ~ Provider
    final createAccountProvider = context.read<CreateAccountProvider>();

    void navigateToNextPage() {
      // TODO: Check form key
      if (!(_formKey.currentState!.validate())) return;

      createAccountProvider.updateUserData(
        firstName: firstnameController.text.trim(),
        lastName: lastnameController.text.trim(),
        dateOfBirth: userAgeController.value,
        gender: userGenderController.value,
        phone: phoneNumberController.text.trim(),
      );

      context.tabsRouter.setActiveIndex(1);
    }

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 38.0) +
            const EdgeInsets.only(top: 10, bottom: 26),

        child: Form(
          key: _formKey,
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

                  const SizedBox(height: 33),

                  Column(
                    spacing: 29,
                    children: [
                      FromTextInputField(
                        controller: firstnameController,
                        label: "Enter first name",
                        validator: (input) => InputValidatorUtils.nonEmptyField(
                          "First name",
                          input,
                        ),
                      ),
                      FromTextInputField(
                        controller: lastnameController,
                        label: "Enter last name",
                        validator: (input) => InputValidatorUtils.nonEmptyField(
                          "Last name",
                          input,
                        ),
                      ),

                      DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        pickerPlatform: DateTimeFieldPickerPlatform.material,
                        decoration: InputDecoration(
                          focusColor: Colors.transparent,
                          hint: Text(
                            'Date of birth',
                            style: hpStyles.r14.copyWith(
                              color: ColorName.textGrayB3,
                            ),
                          ),
                        ),
                        lastDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365 * 100),
                        ),
                        initialPickerDateTime: DateTime.now(),
                        onChanged: (DateTime? value) {
                          userAgeController.value = value;
                        },
                      ),

                      DropdownMenuFormField<UserGender>(
                        width: double.infinity,
                        label: Text(
                          "Gender",
                          style: hpStyles.r14.copyWith(
                            color: ColorName.textGrayB3,
                          ),
                        ),
                        trailingIcon: Assets.icons.caratDown.svg(),
                        onSelected: (gender) {
                          userGenderController.value = gender;
                        },
                        selectedTrailingIcon: RotatedBox(
                          quarterTurns: 2,
                          child: Assets.icons.caratDown.svg(),
                        ),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: UserGender.male,
                            label: "Male",
                          ),
                          DropdownMenuEntry(
                            value: UserGender.female,
                            label: "Female",
                          ),
                        ],
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          elevation: WidgetStateProperty.all(1),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      FromTextInputField(
                        controller: phoneNumberController,
                        label: "Phone no (optional)",
                      ),
                    ],
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  navigateToNextPage();
                },
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
