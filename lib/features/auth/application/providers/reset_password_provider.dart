import 'package:flutter/material.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
