import 'dart:io';

import 'package:flutter/material.dart';

class Publicationurgenceprovider extends ChangeNotifier {
  TextEditingController titreUrgenceController = TextEditingController();
  TextEditingController descriptionUrgenceController = TextEditingController();
  TextEditingController lieuUrgenceController = TextEditingController();
  TextEditingController montantRequisController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    titreUrgenceController.dispose();
    descriptionUrgenceController.dispose();
    lieuUrgenceController.dispose();
    montantRequisController.dispose();
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

  String? typeUrgence = "AUTRE";

  String? get getTypeUrgence => typeUrgence;

  void setTypeAnnonce(String value) {
    typeUrgence = value;
    notifyListeners();
  }
}
