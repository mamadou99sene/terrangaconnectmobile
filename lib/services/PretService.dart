import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/Pret.dart';

class Pretservice {
  Future<List<Pret>> getAllPrets() async {
    List<Pret> allPrets = [];
    http.Response response = await http
        .get(Uri.parse("${API.URL}${API.don_Service}prets"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var pret in responseJson) {
        Pret p = Pret.fromJson(pret);
        allPrets.add(p);
      }
    }
    return allPrets;
  }

  Future<Pret> getPretById(Pret pret) async {
    late Pret returnedPret;
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.don_Service}prets/${pret.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      returnedPret = Pret.fromJson(responseBody);
    }
    return returnedPret;
  }

  Future<bool?> savePretwithImages(Pret pret, List<File> images) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.don_Service}prets"),
      );
      final pretJson = pret.toJson();
      pretJson.forEach((key, value) {
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
