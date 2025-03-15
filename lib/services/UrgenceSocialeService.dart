import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/shared/HttpSharedHeader.dart';

class Urgencesocialeservice {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<List<Urgencesociale>> getAllUrgenceSociales() async {
    List<Urgencesociale> allUrgences = [];
    final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http
        .get(
            Uri.parse(
                "${API.URL}${API.declaration_Service}declarations/urgence"),
            headers: headers)
        .timeout(Duration(seconds: 20));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var urgence in responseJson) {
        Urgencesociale urgencesociale = Urgencesociale.fromJson(urgence);
        allUrgences.add(urgencesociale);
      }
    } else {
      print(" code ${response.statusCode}");
    }
    return allUrgences;
  }

  Future<Urgencesociale> getUrgenceSocialeById(Urgencesociale urgence) async {
    late Urgencesociale urgencesociale;
    final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http
        .get(
            Uri.parse(
                "${API.URL}${API.declaration_Service}declarations/urgence/${urgence.id}"),
            headers: headers)
        .timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      urgencesociale = Urgencesociale.fromJson(responseBody);
    }
    return urgencesociale;
  }

  Future<bool?> saveUrgenceSociale(
      Urgencesociale urgence, List<File> images) async {
    try {
      final String? accessToken = await secureStorage.read(key: 'access_token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.declaration_Service}declarations/urgence"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      final urgenceJson = urgence.toJson();
      urgenceJson.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      for (File image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('images', image.path));
      }

      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 30));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return false;
  }
}
