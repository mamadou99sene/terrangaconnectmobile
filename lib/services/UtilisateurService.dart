import 'dart:convert';
import 'dart:io';

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
}
