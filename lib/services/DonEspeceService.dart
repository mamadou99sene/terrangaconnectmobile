import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/DonEspece.dart';
import 'package:terangaconnect/shared/HttpSharedHeader.dart';

class Donespeceservice {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<List<Donespece>> getAllDonsEspeces() async {
    List<Donespece> allDonEspece = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http
        .get(Uri.parse("${API.URL}${API.don_Service}donsEspece"), headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var donEspece in responseJson) {
        Donespece espece = Donespece.fromJson(donEspece);
        allDonEspece.add(espece);
      }
    }
    return allDonEspece;
  }

  Future<Donespece> getDonEspeceById(Donespece don) async {
    late Donespece returnedEspece;
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.don_Service}donsEspece/${don.id}"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      returnedEspece = Donespece.fromJson(responseBody);
    }
    return returnedEspece;
  }

  Future<Donespece>? saveDonEspece(Donespece don) async {
    late Donespece savedDon;
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http
        .post(Uri.parse("${API.URL}${API.don_Service}donsEspece"),
            headers: headers,
            body: jsonEncode(don.toJson()))
        .timeout(Duration(seconds: 10));
    if (response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      savedDon = Donespece.fromJson(responseBody);
    }
    return savedDon;
  }

  Future<List<Donespece>?> getAllDonEspeceByDeclarationId(
      String declarationId) async {
    List<Donespece> donsEspeces = [];
     final headers = await Httpsharedheader.getAuthHeaders();
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.don_Service}declarations/${declarationId}/donsEspece"),
        headers: headers).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      for (var item in responseBody) {
        Donespece don = Donespece.fromJson(item);
        donsEspeces.add(don);
      }
    }
    return donsEspeces;
  }
}
