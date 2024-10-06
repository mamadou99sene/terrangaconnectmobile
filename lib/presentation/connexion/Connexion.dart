import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/connexion/provider/ConnexionProvider.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/RejectedDialog.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

class Connexion extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
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
                  _buildPhoneInput(context),
                  SizedBox(height: 18.v),
                  _buildPasswordInput(context),
                  SizedBox(height: 18.v),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "mot de passe oublié ?".tr,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.v),
                  _buildConnexionButton(context),
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
                  SizedBox(height: 5.v)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    final provider = Provider.of<Connexionprovider>(context, listen: false);
    return Selector<Connexionprovider, TextEditingController?>(
      selector: (context, provider) => provider.phoneController,
      builder: (context, phoneInputController, child) {
        return CustomTextFormField(
          controller: provider.phoneController,
          obscureText: false,
          hintText: "msg_num_ro_de_t_l_phone".tr,
          textInputType: TextInputType.phone, // Affiche un clavier numérique
        );
      },
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    final provider = Provider.of<Connexionprovider>(context, listen: false);
    return Selector<Connexionprovider, TextEditingController?>(
      selector: (context, provider) => provider.passwordController,
      builder: (context, passwordInputController, child) {
        return Consumer<Connexionprovider>(
          builder: (context, value, child) {
            return CustomTextFormField(
              controller: provider.passwordController,
              hintText: "lbl_mot_de_passe".tr,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    value.change_Visibility();
                    value.changeIcon();
                  },
                  icon: Icon(
                    value.icon,
                    color: Colors.green,
                  )),
              obscureText: value.visibility,
            );
          },
        );
      },
    );
  }

  Widget _buildConnexionButton(BuildContext context) {
    final provider = Provider.of<Connexionprovider>(context, listen: false);
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          provider.telephone = provider.phoneController.text;
          provider.password = provider.passwordController.text;

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
          try {
            //appel service
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }
            if (true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppUrgence(
                            utilisateur: Utilisateur(
                                id: 'fd9020d0-f05c-4f37-87db-6dafda5a0795',
                                email: 'senemamadou1999@gmail.com',
                                telephone: '778340335',
                                roles: []),
                          )));
            } else {
              String title = "Inscription non réussie";
              String message = "Merci de ressayer !!!";
              showRejecteddialogDialog(context, title, message);
            }
          } catch (e) {
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }
            // Afficher une erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur de connexion !!! Retentez")),
            );
          }
        }
      },
      height: 54.v,
      text: "Se connecter".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
