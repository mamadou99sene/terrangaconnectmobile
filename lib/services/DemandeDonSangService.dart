import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/DemandeDonSang.dart';

class Demandedonsangservice {
  Future<List<Demandedonsang>> getAllDemandeDonSang() async {
    List<Demandedonsang> allDemandeDonSang = [];
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.declaration_Service}declarations/donSang"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
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
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.declaration_Service}declarations/donSang/${demandedon.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      demandedonsang = Demandedonsang.fromJson(responseBody);
    }
    return demandedonsang;
  }

  Future<bool> saveDemandedonSang(
      Demandedonsang demandeDonSang, List<File> images) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.URL}${API.declaration_Service}declarations/donSang"),
      );
      final demandeDonJson = demandeDonSang.toJson();
      demandeDonJson.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      for (File image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('images', image.path));
      }
      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return false;
  }
}
