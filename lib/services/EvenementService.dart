import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/Evenement.dart';

import '../shared/HttpSharedHeader.dart';

class Evenementservice {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<List<Evenement>> getAllEvents() async {
    List<Evenement> allEvents = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.declaration_Service}declarations/event/admin"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var event in responseJson) {
        Evenement evenement = Evenement.fromJson(event);
        allEvents.add(evenement);
      }
    }
    return allEvents;
  }

  Future<Evenement> getEventById(Evenement evenement) async {
    late Evenement event;
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.declaration_Service}declarations/event/${evenement.id}"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      event = Evenement.fromJson(responseBody);
    }
    return event;
  }

  Future<bool> saveEvenement(Evenement evenement, List<File> images) async {
    try {
       final String? accessToken = await secureStorage.read(key: 'access_token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.declaration_Service}declarations/event"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      final evenementJson = evenement.toJson();
      evenementJson.forEach((key, value) {
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
