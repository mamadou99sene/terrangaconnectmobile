import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:terangaconnect/config/API.dart';

class KeycloakAuthService {
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Configuration
  final String keycloakUrl = API.KEYCLOAK_SERVER_URL;
  final String realm = 'teranga_realm';
  final String clientId = 'teranga_mobile';
  final String redirectUrl = 'com.example.terangaconnect:/callback';

  // Endpoints
  String get authorizationEndpoint =>
      '$keycloakUrl/realms/$realm/protocol/openid-connect/auth';
  String get tokenEndpoint =>
      '$keycloakUrl/realms/$realm/protocol/openid-connect/token';
  String get userInfoEndpoint =>
      '$keycloakUrl/realms/$realm/protocol/openid-connect/userinfo';
  String get endSessionEndpoint =>
      '$keycloakUrl/realms/$realm/protocol/openid-connect/logout';

  // Login
  Future<bool> login() async {
    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint,
          ),
          scopes: ['openid', 'profile', 'email'],
          allowInsecureConnections: true,
          promptValues: ['login'],
        ),
      );

      if (result != null) {
        await _saveTokens(result);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Rafraîchir le token
  Future<bool> refreshToken() async {
    try {
      final String? refreshToken =
          await secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final TokenResponse? result = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          refreshToken: refreshToken,
          discoveryUrl:
              '$keycloakUrl/realms/$realm/.well-known/openid-configuration',
          grantType: 'refresh_token',
        ),
      );

      if (result != null) {
        await _saveTokens(result);
        return true;
      }
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  // Déconnexion
  Future<bool> logout() async {
    try {
      final String? idToken = await secureStorage.read(key: 'id_token');
      if (idToken == null) return false;

      final EndSessionResponse? result = await appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: redirectUrl,
          discoveryUrl:
              '$keycloakUrl/realms/$realm/.well-known/openid-configuration',
        ),
      );

      await _clearTokens();
      return result != null;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // Sauvegarder les tokens
  Future<void> _saveTokens(dynamic result) async {
    await secureStorage.write(key: 'access_token', value: result.accessToken);
    await secureStorage.write(key: 'refresh_token', value: result.refreshToken);
    if (result.idToken != null) {
      await secureStorage.write(key: 'id_token', value: result.idToken);
    }
  }

  // Effacer les tokens
  Future<void> _clearTokens() async {
    await secureStorage.delete(key: 'access_token');
    await secureStorage.delete(key: 'refresh_token');
    await secureStorage.delete(key: 'id_token');
  }

  // Obtenir les informations utilisateur
Future<Map<String, dynamic>?> getUserInfo() async {
  try {
    final String? accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken == null) return null;
    final response = await http.get(
      Uri.parse(userInfoEndpoint),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final userInfo = jsonDecode(response.body);
      final String userId = userInfo['sub'] ?? 
                            userInfo['id'] ?? 
                            userInfo['user_id'] ?? 
                            '';
      
      // On ajoute l'ID dans les informations retournées
      userInfo['id'] = userId;
      
      return userInfo;
    }
    
    // Option 2: En cas d'échec de l'appel à userinfo, extraire du token
    return _extractUserInfoFromToken(accessToken);
  } catch (e) {
    print('Get user info error: $e');
    return null;
  }
}
  // Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    final String? accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken == null) return false;

    // Token expiré ? Essayer de le rafraîchir
    return refreshToken();
  }

  // Récupérer les rôles
  Future<List<String>> getUserRoles() async {
    try {
      final String? accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken == null) return [];

      // Décoder le JWT pour accéder aux rôles
      final parts = accessToken.split('.');
      if (parts.length != 3) return [];

      String payload = parts[1];
      payload = base64Url.normalize(payload);
      final payloadMap = jsonDecode(utf8.decode(base64Url.decode(payload)));

      // Extraction des rôles realm
      final realmAccess = payloadMap['realm_access'] as Map<String, dynamic>?;
      final roles = realmAccess?['roles'] as List<dynamic>? ?? [];

      return roles.cast<String>();
    } catch (e) {
      print('Get user roles error: $e');
      return [];
    }
  }

Future<bool> isTokenValid() async {
  final String? accessToken = await secureStorage.read(key: 'access_token');
  if (accessToken == null) return false;

  // Décoder le JWT pour vérifier l'expiration
  final parts = accessToken.split('.');
  if (parts.length != 3) return false;

  String payload = parts[1];
  payload = base64Url.normalize(payload);
  final payloadMap = jsonDecode(utf8.decode(base64Url.decode(payload)));
  
  // Vérifier l'expiration
  final exp = payloadMap['exp'] as int;
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  
  print("Token expire à: ${DateTime.fromMillisecondsSinceEpoch(exp * 1000)}");
  print("Heure actuelle: ${DateTime.now()}");
  
  return now < exp;
}
Map<String, dynamic>? _extractUserInfoFromToken(String accessToken) {
  try {
    final parts = accessToken.split('.');
    if (parts.length != 3) return null;

    String payload = parts[1];
    payload = base64Url.normalize(payload);
    final payloadMap = jsonDecode(utf8.decode(base64Url.decode(payload)));
    return {
      'id': payloadMap['sub'] ?? '',
      'email': payloadMap['email'] ?? '',
      'preferred_username': payloadMap['preferred_username'] ?? '',
      'name': payloadMap['name'] ?? '',
      'given_name': payloadMap['given_name'] ?? '',
      'family_name': payloadMap['family_name'] ?? '',
    };
  } catch (e) {
    print('Error extracting user info from token: $e');
    return null;
  }
}
}
