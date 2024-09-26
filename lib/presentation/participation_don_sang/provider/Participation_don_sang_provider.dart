import 'dart:io';

import 'package:flutter/material.dart';

class ParticipationDonSangProvider extends ChangeNotifier {
  TextEditingController addresseDonnateur = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    addresseDonnateur.dispose();
  }
}
