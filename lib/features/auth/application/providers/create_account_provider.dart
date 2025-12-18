import 'package:flutter/material.dart';
import 'package:my_headspace/features/auth/data/models/user_data_model.dart';

class CreateAccountProvider extends ChangeNotifier {
  CreateUserData userData = CreateUserData.empty();

  final formKey = GlobalKey<FormState>();
}
