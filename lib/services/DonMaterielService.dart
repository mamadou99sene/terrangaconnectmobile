import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/DonMateriel.dart';

import '../shared/HttpSharedHeader.dart';

class Donmaterielservice {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<List<Donmateriel>> getAllDonsMateriels() async {
    List<Donmateriel> allDonsMateriels = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http
        .get(Uri.parse("${API.URL}${API.don_Service}donsMateriel"), headers:headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var don in responseJson) {
        Donmateriel donmateriel = Donmateriel.fromJson(don);
        allDonsMateriels.add(donmateriel);
      }
    }
    return allDonsMateriels;
  }

  Future<Donmateriel> getDonMaterielById(Donmateriel don) async {
    late Donmateriel returnedDon;
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.don_Service}donsMateriel/${don.id}"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      returnedDon = Donmateriel.fromJson(responseBody);
    }
    return returnedDon;
  }

  Future<bool> saveDonMaterielwithImages(
      Donmateriel donMateriel, List<File> images) async {
    try {
       final String? accessToken = await secureStorage.read(key: 'access_token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.don_Service}donsMateriel"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      final donMaterielJson = donMateriel.toJson();
      donMaterielJson.forEach((key, value) {
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

  Future<List<Donmateriel>?> getAllDonMaterielByDeclarationId(
      String declarationId) async {
    List<Donmateriel> donsMateriels = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.don_Service}declarations/${declarationId}/donsMateriel"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in responseBody) {
        Donmateriel don = Donmateriel.fromJson(item);
        donsMateriels.add(don);
      }
    }
    return donsMateriels;
  }
}
