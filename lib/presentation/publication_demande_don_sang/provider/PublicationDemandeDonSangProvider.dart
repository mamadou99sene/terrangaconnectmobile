import 'dart:io';

import 'package:flutter/material.dart';

class Publicationdemandedonsangprovider extends ChangeNotifier {
  TextEditingController titreEventController = TextEditingController();
  TextEditingController descriptionEventController = TextEditingController();
  TextEditingController adresseEventController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  TextEditingController rhesusController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    titreEventController.dispose();
    descriptionEventController.dispose();
    adresseEventController.dispose();
    classeController.dispose();
    rhesusController.dispose();
  }

  List<File> _selectedImages = [];

  List<File> get selectedImages => _selectedImages;

  void addImage(File image) {
    if (_selectedImages.length < 3) {
      _selectedImages.add(image);
      notifyListeners();
    }
  }

  void setImages(List<File> newImages) {
    _selectedImages = newImages;
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  String? classeSang = "A";

  String? get getClasse => classeSang;

  void setClasse(String value) {
    classeSang = value;
    notifyListeners();
  }

  String? rhesus = "POSITIF";
  String? getRhesus() {
    return rhesus;
  }

  void setRhesus(String rhesus) {
    this.rhesus = rhesus;
    notifyListeners();
  }
}
