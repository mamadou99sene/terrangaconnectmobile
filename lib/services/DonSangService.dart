import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/DonSang.dart';

class Donsangservice {
  Future<List<Donsang>> getAllDonsSang() async {
    List<Donsang> allDonSang = [];
    http.Response response = await http
        .get(Uri.parse("${API.URL}${API.don_Service}donsSang"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(Duration(seconds: 10));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in responseJson) {
        Donsang donsang = Donsang.fromJson(item);
        allDonSang.add(donsang);
      }
    }
    return allDonSang;
  }

  Future<Donsang> getDonSangById(Donsang donsang) async {
    late Donsang returnedDon;
    http.Response response = await http.get(
        Uri.parse("${API.URL}${API.don_Service}donsSang/${donsang.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      returnedDon = Donsang.fromJson(responseBody);
    }
    return returnedDon;
  }

  Future<Donsang?> saveDonSang(Donsang donSang) async {
    late Donsang savedDonSang;
    http.Response response = await http
        .post(Uri.parse("${API.URL}${API.don_Service}donsSang"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(donSang.toJson()))
        .timeout(Duration(seconds: 10));
    if (response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      savedDonSang = Donsang.fromJson(responseBody);
    }
    return savedDonSang;
  }

  Future<List<Donsang>?> getAllDonSangByDeclarationId(
      String declarationId) async {
    List<Donsang> donsSang = [];
    http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.don_Service}declarations/${declarationId}/donsSang"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      for (var item in responseBody) {
        Donsang don = Donsang.fromJson(item);
        donsSang.add(don);
      }
    }
    return donsSang;
  }
}
