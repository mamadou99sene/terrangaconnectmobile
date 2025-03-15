import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terangaconnect/models/Utilisateur.dart';

import '../../services/AuthService.dart';
import '../AppUrgence.dart';
import 'Connexion.dart';

class AuthCheckWrapper extends StatefulWidget {
  @override
  _AuthCheckWrapperState createState() => _AuthCheckWrapperState();
}

class _AuthCheckWrapperState extends State<AuthCheckWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authService =
        Provider.of<KeycloakAuthService>(context, listen: false);
    final isAuthenticated = await authService.isAuthenticated();

    if (isAuthenticated) {
      final userInfo = await authService.getUserInfo();
      final roles = await authService.getUserRoles();
      
      if (userInfo != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AppUrgence(
                        utilisateur: Utilisateur(
                      email: userInfo['email'] ?? '',
                      telephone: userInfo['preferred_username'] ?? '',
                      roles: roles,
                    ))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Connexion();
  }
}
