import 'dart:io';

import 'package:flutter/material.dart';

class ParticipationMaterielProvider extends ChangeNotifier {
  TextEditingController titrePretController = TextEditingController();
  TextEditingController descriptionPretController = TextEditingController();
  TextEditingController dureeController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    titrePretController.dispose();
    descriptionPretController.dispose();
    dureeController.dispose();
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
}
