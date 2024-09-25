import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:http/http.dart' as http;

class Urgencesocialeservice {
  Future<List<Urgencesociale>> getAllUrgenceSociales() async {
    List<Urgencesociale> allUrgences = [];
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.declaration_Service}declarations/urgence"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var urgence in responseJson) {
        Urgencesociale urgencesociale = Urgencesociale.fromJson(urgence);
        allUrgences.add(urgencesociale);
      }
    }
    return allUrgences;
  }

  Future<Urgencesociale> getUrgenceSocialeById(Urgencesociale urgence) async {
    late Urgencesociale urgencesociale;
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.declaration_Service}declarations/urgence/${urgence.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      urgencesociale = Urgencesociale.fromJson(responseBody);
    }
    return urgencesociale;
  }

  Future<bool?> saveUrgenceSociale(
      Urgencesociale urgence, List<File> images) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.declaration_Service}declarations/urgence"),
      );
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
