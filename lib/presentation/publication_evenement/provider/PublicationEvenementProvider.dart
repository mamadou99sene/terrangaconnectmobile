import 'dart:io';

import 'package:flutter/material.dart';

class Publicationevenementprovider extends ChangeNotifier {
  TextEditingController titreEventController = TextEditingController();
  TextEditingController descriptionEventController = TextEditingController();
  TextEditingController lieuEventController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    titreEventController.dispose();
    descriptionEventController.dispose();
    lieuEventController.dispose();
    endDateController.dispose();
    startDateController.dispose();
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

  String? typeEvent = "AUTRE";

  String? get getTypeEvent => typeEvent;

  void setTypeAnnonce(String value) {
    typeEvent = value;
    notifyListeners();
  }
}
