import 'package:flutter/material.dart';
import 'package:terangaconnect/core/utils/pref_utils.dart';
import '../../core/app_export.dart';

class ThemeProvider extends ChangeNotifier {
  themeChange(String themeType) async {
    PrefUtils().setThemeData(themeType);
    notifyListeners();
  }
}
