import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/DonEspece.dart';

class Donespeceservice {
  Future<List<Donespece>> getAllDonsEspeces() async {
    List<Donespece> allDonEspece = [];
    http.Response response = await http
        .get(Uri.parse("${API.URL}${API.don_Service}donsEspece"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(Duration(seconds: 10));
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
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.don_Service}donsEspece/${don.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      returnedEspece = Donespece.fromJson(responseBody);
    }
    return returnedEspece;
  }

  Future<Donespece>? saveDonEspece(Donespece don) async {
    late Donespece savedDon;
    http.Response response = await http
        .post(Uri.parse("${API.URL}${API.don_Service}donsEspece"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(don.toJson()))
        .timeout(Duration(seconds: 10));
    if (response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      savedDon = Donespece.fromJson(responseBody);
    }
    return savedDon;
  }
}
