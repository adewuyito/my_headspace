import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/colors.gen.dart';

/// A premium, standardized utility for displaying beautifully styled floating snackbars.
class SnackbarUtils {
  SnackbarUtils._();

  static void _showCustomSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color textColor = ColorName.textPositive,
  }) {
    // Dismiss any active snackbars immediately for instant user feedback
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: hpStyles.r14.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }

  /// Displays a floating error snackbar with an error icon.
  static void showError(BuildContext context, String message) {
    _showCustomSnackbar(
      context: context,
      message: message,
      backgroundColor: ColorName.error,
      icon: Icons.error_outline_rounded,
    );
  }

  /// Displays a floating success snackbar with a checkmark icon.
  static void showSuccess(BuildContext context, String message) {
    _showCustomSnackbar(
      context: context,
      message: message,
      backgroundColor: ColorName.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Displays a floating warning snackbar with an amber warning icon.
  static void showWarning(BuildContext context, String message) {
    _showCustomSnackbar(
      context: context,
      message: message,
      backgroundColor: ColorName.warning,
      icon: Icons.warning_amber_rounded,
      textColor: ColorName.textNegative,
    );
  }

  /// Displays a floating info snackbar with an information icon.
  static void showInfo(BuildContext context, String message) {
    _showCustomSnackbar(
      context: context,
      message: message,
      backgroundColor: ColorName.info,
      icon: Icons.info_outline_rounded,
    );
  }
}
