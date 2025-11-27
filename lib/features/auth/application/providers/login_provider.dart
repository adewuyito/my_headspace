import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form state
  bool acceptTerms = false;
  bool isLoading = false;
  int currentStep = 0; // 0 for first page, 1 for second page

  // Validation state
  Map<String, String> formErrors = {};

  // Clear all form data
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    acceptTerms = false;
    formErrors.clear();
    currentStep = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
