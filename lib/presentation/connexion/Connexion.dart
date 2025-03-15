import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/services/AuthService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';

import '../../models/Utilisateur.dart';
import '../../widgets/RejectedDialog.dart';
import '../AppUrgence.dart';

class Connexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Injectez le service d'authentification via Provider si nécessaire
    final authService =
        Provider.of<KeycloakAuthService>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 19.h,
              vertical: 57.v,
            ),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imageTeranga,
                  height: 76.v,
                  width: 87.h,
                ),
                SizedBox(height: 16.v),
                Text(
                  "lbl_connexion".tr,
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 70.v),
                CustomElevatedButton(
                  onPressed: () async {
                    try {
                      BuildContext? dialogContext;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          dialogContext = context;
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: Center(
                                child: SpinKitCircle(
                              color: Colors.green,
                              size: 50,
                            )),
                          );
                        },
                      );

                      final success = await authService.login();

                      if (dialogContext != null &&
                          Navigator.canPop(dialogContext!)) {
                        Navigator.pop(dialogContext!);
                      }

                      if (success) {
                        final userInfo = await authService.getUserInfo();
                        final roles = await authService.getUserRoles();

                        if (userInfo != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppUrgence(
                                          utilisateur: Utilisateur(
                                        id: userInfo['id'],
                                        email: userInfo['email'] ?? '',
                                        telephone:
                                            userInfo['preferred_username'] ??
                                                '',
                                        roles: roles,
                                      ))));
                        }
                      } else {
                        String title = "Connexion non réussie";
                        String message =
                            "Identifiants incorrects. Merci de ressayer !!!";
                        showRejecteddialogDialog(context, title, message);
                      }
                    } catch (e) {
                      print('Erreur de connexion: $e');
                      String title = "Erreur";
                      String message =
                          "Une erreur s'est produite. Veuillez réessayer.";
                      showRejecteddialogDialog(context, title, message);
                    }
                  },
                  height: 54.v,
                  text: "Se connecter".tr,
                  buttonStyle: CustomButtonStyles.fillPrimary,
                ),
                SizedBox(height: 29.v),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/inscription');
                  },
                  child: Text(
                    "msg_je_n_ai_pas_un_compte".tr,
                    style: CustomTextStyles.titleMediumGray50001,
                  ),
                ),
                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
