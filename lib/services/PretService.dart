import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/Pret.dart';
import 'package:terangaconnect/shared/HttpSharedHeader.dart';

class Pretservice {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<List<Pret>> getAllPrets() async {
    List<Pret> allPrets = [];
    final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http
        .get(Uri.parse("${API.URL}${API.don_Service}prets"), headers: headers)
        .timeout(Duration(seconds: 10));
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
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.don_Service}prets/${pret.id}"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      returnedPret = Pret.fromJson(responseBody);
    }
    return returnedPret;
  }

  Future<bool> savePretwithImages(Pret pret, List<File> images) async {
    try {
       final String? accessToken = await secureStorage.read(key: 'access_token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.don_Service}prets"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
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

  Future<List<Pret>?> getAllPretsByDeclarationId(String declarationId) async {
    List<Pret> declarationPrets = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.don_Service}declarations/${declarationId}/prets"),
        headers:headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in responseBody) {
        Pret pret = Pret.fromJson(item);
        declarationPrets.add(pret);
      }
    }
    return declarationPrets;
  }
}
