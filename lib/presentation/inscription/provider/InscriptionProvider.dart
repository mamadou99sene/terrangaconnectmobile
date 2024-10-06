import 'package:flutter/material.dart';

class Inscriptionprovider extends ChangeNotifier {
  TextEditingController phoneInputController = TextEditingController();

  TextEditingController emailInputController = TextEditingController();

  TextEditingController passwordInputController = TextEditingController();
  late String email = '';
  late String telephone = '';
  late String password = '';
  IconData icon = Icons.visibility;
  bool visibility = false;
  void change_Visibility() {
    visibility = !visibility;
    notifyListeners();
  }

  void changeIcon() {
    if (visibility == true) {
      icon = Icons.visibility_off;
      notifyListeners();
    } else {
      icon = Icons.visibility;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneInputController.dispose();
    emailInputController.dispose();
    passwordInputController.dispose();
  }

  bool activebutton = false;

  NewPasswordProvider() {
    print(phoneInputController.text);
    phoneInputController.addListener(_onValidInformations);
    emailInputController.addListener(_onValidInformations);
    passwordInputController.addListener(_onValidInformations);
  }

  void _onValidInformations() {
    email = emailInputController.text;
    telephone = phoneInputController.text;
    password = passwordInputController.text;
    if (email.trim().isNotEmpty &&
        telephone.trim().isNotEmpty &&
        password.trim().isNotEmpty) {
      activebutton =
          false; //isValidPhone(email, Set.of({true}),isRequired: true);
    } else {
      activebutton = true;
    }
    notifyListeners();
  }
}
