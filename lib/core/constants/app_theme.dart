// base theme
import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/core/constants/text_theme.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/gen/fonts.gen.dart';

final baseTheme = ThemeData.light();

// base border
final inputBorderBase = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: ColorName.borderGrey),
);

final ThemeData headspaceTheme = baseTheme.copyWith(
  scaffoldBackgroundColor: ColorName.background,
  // primaryColor: appColors.blue,
  appBarTheme: AppBarTheme(
    // backgroundColor: appColors.white,
    elevation: 0,
    // foregroundColor: appColors.black,
  ),
  colorScheme: baseTheme.colorScheme.copyWith(
    surface: ColorName.background,
    // secondary: appColors.blue,
  ),
  // dividerColor: appColors.dividerGrey,
  brightness: Brightness.light,
  buttonTheme: baseTheme.buttonTheme.copyWith(
    height: 55,
    minWidth: double.infinity,
    buttonColor: ColorName.background,
    textTheme: ButtonTextTheme.normal,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF104423),
      foregroundColor: ColorName.textPositive,
      textStyle: hpStyles.m16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 55),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),
  tabBarTheme: baseTheme.tabBarTheme.copyWith(
    labelStyle: baseTheme.textTheme.bodySmall!.copyWith(
      // color: appColors.blue,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: baseTheme.textTheme.bodySmall!.copyWith(
      // color: appColors.black,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    // indicatorColor: appColors.blue,
    // labelColor: appColors.blue,
    // unselectedLabelColor: appColors.black,
  ),
  inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    border: inputBorderBase,
    enabledBorder: inputBorderBase,
    focusedBorder: inputBorderBase,
    fillColor: Colors.transparent,
    filled: false,
    hintStyle: hpStyles.r14, //.copyWith(color: ColorName.textGrayB3),
    labelStyle: TextStyle(
      fontSize: 12,
      // color: appColors.lightGreyAAABAD,
      fontWeight: FontWeight.w400,
      // fontFamily: FontFamily.generalSans,
    ),
  ),
  textTheme: hpTextTheme.apply(fontFamily: FontFamily.montserrat),
);
