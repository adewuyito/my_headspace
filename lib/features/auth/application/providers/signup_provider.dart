import 'package:flutter/material.dart';
import 'package:my_headspace/features/auth/application/enums/user_gender_enum.dart';

class SignupProvider with ChangeNotifier {
  // Text Controllers
  final TextEditingController usernameNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  DateTime? userAgeController;
  UserGender? userGenderController;

  // Form state
  bool acceptTerms = false;
  bool isLoading = false;
  int currentStep = 0; // 0 for first page, 1 for second page

  // Validation state
  Map<String, String> formErrors = {};

  // Method to go to the next step
  bool goToNextStep() {
    if (_validateCurrentStep()) {
      currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Method to go back to the previous step
  void goToPreviousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  // Validate only the fields for the current step
  bool _validateCurrentStep() {
    formErrors.clear();

    if (currentStep == 0) {
      _validatePersonalInfo();
      _validateDOB();
    }
    

    notifyListeners();
    return formErrors.isEmpty;
  }

  // Validate all fields for final submission
  bool validateAllFields() {
    formErrors.clear();

    _validatePersonalInfo();
    _validateAccountInfo();

    notifyListeners();
    return formErrors.isEmpty;
  }

  void _validatePersonalInfo() {
    if (firstNameController.text.trim().isEmpty) {
      formErrors['firstName'] =
          'First name is required'; // TODO! Replace with error exception
    }
    if (lastNameController.text.trim().isEmpty) {
      formErrors['lastName'] = 'Last name is required';
    }
  }

  void _validateDOB() {
    if (userAgeController == null || userAgeController == DateTime.now()) {
      formErrors['date of birth'] = 'Enter a valid date of birth';
    }
  }

  void _validateAccountInfo() {
    if (emailController.text.trim().isEmpty) {
      formErrors['email'] = 'Email is required';
    } else if (!_isValidEmail(emailController.text.trim())) {
      formErrors['email'] = 'Please enter a valid email address';
    }

    if (passwordController.text.isEmpty) {
      formErrors['password'] = 'Password is required';
    } else if (passwordController.text.length < 8) {
      formErrors['password'] = 'Password must be at least 8 characters';
    }

    if (confirmPasswordController.text.isEmpty) {
      formErrors['confirmPassword'] = 'Please confirm your password';
    } else if (passwordController.text != confirmPasswordController.text) {
      formErrors['confirmPassword'] = 'Passwords do not match';
    }

    if (!acceptTerms) {
      formErrors['terms'] = 'You must accept the terms and conditions';
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Submit the signup form
  Future<bool> submitSignup() async {
    if (!validateAllFields()) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Perform your signup API call here
      // Example:
      // await signupService.registerUser(
      //   firstName: firstNameController.text.trim(),
      //   lastName: lastNameController.text.trim(),
      //   email: emailController.text.trim(),
      //   password: passwordController.text,
      // );

      // If signup is successful
      return true;
    } catch (e) {
      formErrors['general'] = 'Signup failed. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Clear all form data
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    acceptTerms = false;
    formErrors.clear();
    currentStep = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
