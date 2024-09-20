import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/Evenement.dart';

class Evenementservice {
  Future<List<Evenement>> getAllEvents() async {
    List<Evenement> allEvents = [];
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.declaration_Service}declarations/event"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      for (var event in responseJson) {
        Evenement evenement = Evenement.fromJson(event);
        allEvents.add(evenement);
      }
    }
    return allEvents;
  }

  Future<Evenement> getEventById(Evenement evenement) async {
    late Evenement event;
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.declaration_Service}declarations/event/${evenement.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      event = Evenement.fromJson(responseBody);
      print(event.toJson());
    }
    return event;
  }

  Future<bool> saveEvenement(Evenement evenement, List<File> images) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.declaration_Service}declarations/event"),
      );
      final evenementJson = evenement.toJson();
      evenementJson.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      for (File image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('images', image.path));
      }
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return false;
  }
}
