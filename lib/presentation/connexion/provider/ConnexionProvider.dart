import 'package:flutter/material.dart';

class Connexionprovider extends ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
    phoneController.dispose();
    passwordController.dispose();
  }

  bool activebutton = false;
}
