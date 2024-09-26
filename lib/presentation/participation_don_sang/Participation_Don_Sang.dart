import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/DonSang.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/participation_don_sang/provider/Participation_don_sang_provider.dart';
import 'package:terangaconnect/services/DonSangService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/ConfirmationDialog.dart';
import 'package:terangaconnect/widgets/RejectedDialog.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

class ParticipationDonSang extends StatelessWidget {
  late String declarationId;
  late Utilisateur utilisateur;
  ParticipationDonSang(
      {required this.declarationId, required this.utilisateur});
  TextEditingController controllerAdresseDonnateur = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
                vertical: 15.v,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10.v),
                  CustomImageView(
                    imagePath: ImageConstant.imageTeranga,
                    height: 76.v,
                    width: 87.h,
                  ),
                  SizedBox(height: 18.v),
                  Text(
                    "part_".tr,
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 43.v),
                  _buildDonSangAdresseDonnateur(context),
                  SizedBox(height: 29.v),
                  SizedBox(height: 21.v),
                  _buildDonSangButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonSangAdresseDonnateur(BuildContext context) {
    return Selector<ParticipationDonSangProvider, TextEditingController?>(
      selector: (context, provider) => provider.addresseDonnateur,
      builder: (context, articleController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 12.v),
                child: Text(
                  "Donner votre adresse".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            CustomTextFormField(
              controller: controllerAdresseDonnateur,
              hintText: "Votre adresse ici".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "votre adresse".tr;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonSangButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          //recuperation des entrées utilisateur
          String adresseDonnateur = controllerAdresseDonnateur.text;

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
          Donsang donsang = Donsang(
              type: 'SANG',
              declarationId: declarationId,
              donateurId: utilisateur.id!,
              adresseDonnateur: adresseDonnateur);
          try {
            Donsang? savedDonSang = await Donsangservice().saveDonSang(donsang);
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }
            if (savedDonSang != null) {
              String message =
                  "Vous etes enregistré sur la liste des donnateurs. Merci beaucoup pour votre intervention.";
              showConfirmationDialog(context, message, () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppUrgence(
                              utilisateur: utilisateur,
                            )));
              });
            } else {
              String title = "Don non envoyé";
              String message = "Merci de ressayer !!!";
              showRejecteddialogDialog(context, title, message);
            }
          } catch (e) {
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }

            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur de connexion !!! Retentez")),
            );
          }
        } else
          print("Invalid");
      },
      height: 54.v,
      text: "Valider votre don".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
