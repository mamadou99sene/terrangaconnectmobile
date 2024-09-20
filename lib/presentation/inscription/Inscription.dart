import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/core/utils/validation_functions.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/inscription/provider/InscriptionProvider.dart';
import 'package:terangaconnect/services/UtilisateurService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_icon_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

class Inscription extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Utilisateur utilisateur;
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
              vertical: 47.v,
            ),
            child: Column(
              children: [
                SizedBox(height: 10.v),
                CustomImageView(
                  imagePath: ImageConstant.imgUserErrorcontainer,
                  height: 76.v,
                  width: 87.h,
                ),
                SizedBox(height: 18.v),
                Text(
                  "lbl_inscription".tr,
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 43.v),
                _buildPhoneInput(context),
                SizedBox(height: 20.v),
                _buildEmailInput(context),
                SizedBox(height: 20.v),
                _buildPasswordInput(context),
                SizedBox(height: 20.v),
                Consumer<Inscriptionprovider>(
                  builder: (context, value, child) {
                    return _buildRegistrationButton(
                        context, value.activebutton);
                  },
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.primaryColor,
                          )),
                      Text(
                        "msg_j_ai_d_j_un_compte".tr,
                        style: CustomTextStyles.titleMediumGray50001,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 29.v),
                _buildDividerRow(context),
                SizedBox(height: 21.v),
                Padding(
                  padding: EdgeInsets.only(
                    left: 42.h,
                    right: 50.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.h),
                        child: CustomIconButton(
                          onTap: () {
                            //googleSignIn(context);
                          },
                          height: 54.v,
                          width: 69.h,
                          padding: EdgeInsets.all(14.h),
                          decoration: IconButtonStyleHelper.outlineGray,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFrame,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    final provider = Provider.of<Inscriptionprovider>(context, listen: false);
    return Selector<Inscriptionprovider, TextEditingController?>(
      selector: (context, provider) => provider.phoneInputController,
      builder: (context, phoneInputController, child) {
        return CustomTextFormField(
          controller: provider.phoneInputController,
          obscureText: false,
          hintText: "msg_num_ro_de_t_l_phone".tr,
          textInputType: TextInputType.phone, // Affiche un clavier numérique
          validator: (value) {
            final phoneRegex = RegExp(r'^(33|77|78|76|88|75)\d{7}$');
            if (value == null || !phoneRegex.hasMatch(value)) {
              return "Veuillez donner un numero valide";
            }
            return null;
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    final provider = Provider.of<Inscriptionprovider>(context, listen: false);
    return Selector<Inscriptionprovider, TextEditingController?>(
      selector: (context, provider) => provider.emailInputController,
      builder: (context, emailInputController, child) {
        return CustomTextFormField(
          controller: provider.emailInputController,
          textInputType: TextInputType.emailAddress,
          obscureText: false,
          hintText: "lbl_adresse_mail".tr,
          validator: (value) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value ?? '')) {
              return 'Veuillez saisir une adresse e-mail valide'; // Retournez un message d'erreur non vide
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    final provider = Provider.of<Inscriptionprovider>(context, listen: false);
    return Selector<Inscriptionprovider, TextEditingController?>(
      selector: (context, provider) => provider.passwordInputController,
      builder: (context, passwordInputController, child) {
        return Consumer<Inscriptionprovider>(
          builder: (context, value, child) {
            return CustomTextFormField(
              controller: provider.passwordInputController,
              hintText: "lbl_mot_de_passe".tr,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.phone,
              suffixIcon: IconButton(
                  onPressed: () {
                    value.change_Visibility();
                    value.changeIcon();
                  },
                  icon: Icon(
                    value.icon,
                    color: Colors.green,
                  )),
              validator: (value) {
                if (value == null ||
                    (!isValidPassword(value, isRequired: true))) {
                  return "Donner un mot de passe valide".tr;
                }
                return null;
              },
              obscureText: value.visibility,
            );
          },
        );
      },
    );
  }

  Widget _buildRegistrationButton(BuildContext context, bool isDisabled) {
    final provider = Provider.of<Inscriptionprovider>(context, listen: false);
    return CustomElevatedButton(
      onPressed: isDisabled
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                provider.email = provider.emailInputController.text;
                provider.telephone = provider.phoneInputController.text;
                provider.password = provider.passwordInputController.text;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                        child: SpinKitCircle(
                      color: Colors.green,
                      size: 50,
                    ));
                  },
                );
                try {
                  utilisateur = Utilisateur(
                      email: provider.email,
                      telephone: provider.telephone,
                      password: provider.password,
                      roles: ["USER"]);
                  Utilisateur? savedUser =
                      await Utilisateurservice().saveUtilisateur(utilisateur);
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();

                  // Afficher une erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur de connexion !!! Retentez")),
                  );
                }
                print(provider.email);
              }
            },
      height: 54.v,
      isDisabled: isDisabled,
      text: "Confirmer".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }

  /// Section Widget
  Widget _buildDividerRow(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(left: 19.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 8.v,
                bottom: 6.v,
              ),
              child: SizedBox(
                width: 113.h,
                child: Divider(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: Text(
                "lbl_ou_utiliser".tr,
                style: CustomTextStyles.labelLargeGray50001,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(
                top: 8.v,
                bottom: 6.v,
              ),
              child: SizedBox(
                width: 113.h,
                child: Divider(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
