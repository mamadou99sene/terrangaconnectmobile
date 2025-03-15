import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:terangaconnect/services/AuthService.dart';

class Httpsharedheader {
  static FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<Map<String, String>> getAuthHeaders() async {
    if (!await KeycloakAuthService().isTokenValid()) {
      print("Token expiré, tentative de rafraîchissement...");
      // Rafraîchir le token
      bool refreshed = await KeycloakAuthService().refreshToken();
      if (!refreshed) {
        print("Échec du rafraîchissement du token");
        // Gérer l'échec (peut-être rediriger vers login)
      } else {
        print("Token rafraîchi avec succès");
      }
    }

    final String? accessToken = await secureStorage.read(key: 'access_token');
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };
  }
}
