// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:auto_route/annotations.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/shared/widgets/shared_textfield.dart';

@routePage
class CreateAccountPage1 extends HookWidget {
  const CreateAccountPage1({super.key});

  @override
  Widget build(BuildContext context) {
    // ~ Text Controller
    final _firstName = useTextEditingController();
    final _lastName = useTextEditingController();
    final _phoneNumber = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
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

                const SizedBox(height: 33),

                Form(
                  child: Column(
                    spacing: 29,
                    children: [
                      FromTextInputField(
                        controller: _firstName,
                        label: "Enter first name",
                      ),
                      FromTextInputField(
                        controller: _lastName,
                        label: "Enter last name",
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
                          // selectedDate = value;
                        },
                      ),

                      DropdownMenuFormField(
                        width: double.infinity,
                        label: Text(
                          "Gender",
                          style: hpStyles.r14.copyWith(
                            color: ColorName.textGrayB3,
                          ),
                        ),
                        trailingIcon: Assets.icons.caratDown.svg(),
                        selectedTrailingIcon: RotatedBox(
                          quarterTurns: 2,
                          child: Assets.icons.caratDown.svg(),
                        ),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 'T', label: "Male"),
                          DropdownMenuEntry(value: 'T', label: "Female"),
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
                        controller: _phoneNumber,
                        label: "Phone no (optional)",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Container(
            //   child: ,
            // )
            ElevatedButton(
              onPressed: () {},
              child: Text("Next" ),
            ),
          ],
        ),
      ),
    );
  }
}

