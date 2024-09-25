import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/services/UtilisateurService.dart';
import 'package:terangaconnect/models/Utilisateur.dart';

class Monprofileprovider extends ChangeNotifier {
  Uint8List? _profileImage;
  bool _isLoading = false;
  String? _error;
  Utilisateur? _utilisateur;

  Uint8List? get profileImage => _profileImage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Utilisateur? get utilisateur => _utilisateur;

  final Utilisateurservice _utilisateurService = Utilisateurservice();

  Future<void> loadProfileImage(Utilisateur utilisateur) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profileImage = await _utilisateurService.getUserProfile(utilisateur);
      _utilisateur = utilisateur;
    } catch (e) {
      _error = 'Erreur lors du chargement de l\'image de profil: $e';
      print(_error);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> pickAndSaveImage(ImageSource source) async {
    if (_utilisateur == null) {
      _error = 'Erreur : Utilisateur non défini';
      notifyListeners();
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        final imageBytes = await pickedFile.readAsBytes();
        
        // Envoyer l'image au backend
        Utilisateur? updatedUtilisateur = await _utilisateurService.saveProfile(utilisateur!, imageBytes);
        
        if (updatedUtilisateur != null) {
          _profileImage = imageBytes;
          _utilisateur = updatedUtilisateur;
        } else {
          _error = 'Échec de l\'enregistrement de l\'image de profil';
        }
      } catch (e) {
        _error = 'Erreur lors de l\'enregistrement de l\'image de profil: $e';
        print(_error);
      }

      _isLoading = false;
      notifyListeners();
    }
  }
}