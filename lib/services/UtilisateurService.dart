import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:http/http.dart' as http;

class Utilisateurservice {
  Future<Utilisateur?> saveUtilisateur(Utilisateur utilisateur) async {
    late Utilisateur savedUser;
    http.Response response = await http.post(
        Uri.parse("${API.URL}${API.user_Service}utilisateurs/register"),
        body: jsonEncode(utilisateur.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      savedUser = Utilisateur.fromJson(responseBody);
    }
    return savedUser;
  }

  Future<Utilisateur> getutilisateurById(Utilisateur utilisateur) async {
    late Utilisateur returnedUser;
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.user_Service}utilisateurs/${utilisateur.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      returnedUser = Utilisateur.fromJson(responseBody);
    }
    return returnedUser;
  }

  Future<Uint8List?> getUserProfile(Utilisateur utilisateur) async {
    late Uint8List profile;
    http.Response response = await http
        .get(Uri.parse(
            "${API.URL}${API.user_Service}utilisateurs/${utilisateur.id}/profile"))
        .timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      profile = response.bodyBytes;
    }
    return profile;
  }
   Future<Utilisateur?> saveProfile(Utilisateur user, Uint8List imageBytes) async {
    final url = Uri.parse("${API.URL}${API.user_Service}utilisateurs/profile");
    
    try {
      var request = http.MultipartRequest('PUT', url);
      
      // Ajout des paramètres
      request.fields['id'] = user.id!;
      
      // Ajout du fichier
      request.files.add(http.MultipartFile.fromBytes(
        'profile',
        imageBytes,
        filename: 'profile.jpg',
      ));

      var streamedResponse = await request.send().timeout(Duration(seconds: 10));
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == HttpStatus.CREATED) {
        print('Profile image uploaded successfully');
        // Parsing de la réponse JSON en objet Utilisateur
        return Utilisateur.fromJson(json.decode(response.body));
      } else {
        print('Failed to upload profile image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }
}
