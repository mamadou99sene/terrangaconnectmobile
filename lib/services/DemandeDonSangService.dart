import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/DemandeDonSang.dart';
import 'package:terangaconnect/shared/HttpSharedHeader.dart';

class Demandedonsangservice {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<List<Demandedonsang>> getAllDemandeDonSang() async {
    List<Demandedonsang> allDemandeDonSang = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.declaration_Service}declarations/donSang"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var demande in responseJson) {
        Demandedonsang demandedonsang = Demandedonsang.fromJson(demande);
        allDemandeDonSang.add(demandedonsang);
      }
    }
    return allDemandeDonSang;
  }

  Future<Demandedonsang> getDemandeDonSangById(
      Demandedonsang demandedon) async {
    late Demandedonsang demandedonsang;
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.declaration_Service}declarations/donSang/${demandedon.id}"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      demandedonsang = Demandedonsang.fromJson(responseBody);
    }
    return demandedonsang;
  }

  Future<bool> saveDemandedonSang(
      Demandedonsang demandeDonSang, List<File> images) async {
    try {
       final String? accessToken = await secureStorage.read(key: 'access_token');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.declaration_Service}declarations/donSang"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      final demandeDonJson = demandeDonSang.toJson();
      demandeDonJson.forEach((key, value) {
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
