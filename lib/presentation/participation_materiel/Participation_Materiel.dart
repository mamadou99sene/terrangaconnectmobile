import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/DonMateriel.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/participation_materiel/provider/Participation_Materiel_Provider.dart';
import 'package:terangaconnect/services/DonMaterielService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/ConfirmationDialog.dart';
import 'package:terangaconnect/widgets/RejectedDialog.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

class ParticipationMateriel extends StatelessWidget {
  late String declarationId;
  late Utilisateur utilisateur;
  ParticipationMateriel(
      {required this.declarationId, required this.utilisateur});
  TextEditingController controllerTitre = TextEditingController();
  TextEditingController controllerDescritpion = TextEditingController();
  TextEditingController controllerDuree = TextEditingController();
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
                  _buildDonMaterielTitle(context),
                  SizedBox(height: 12.v),
                  _buildDonDescription(context),
                  SizedBox(height: 29.v),
                  _buildImagesDonMateriel(context),
                  SizedBox(height: 29.v),
                  SizedBox(height: 21.v),
                  _buildValidDonMaterielButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonMaterielTitle(BuildContext context) {
    return Selector<ParticipationMaterielProvider, TextEditingController?>(
      selector: (context, provider) => provider.titrePretController,
      builder: (context, articleController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 12.v),
                child: Text(
                  "Titre de ce que vous donner".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            CustomTextFormField(
              controller: controllerTitre,
              hintText: "Titre de votre don".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "le titre".tr;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description de ce que vous donner ...",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<ParticipationMaterielProvider, TextEditingController?>(
          selector: (context, provider) => provider.descriptionPretController,
          builder: (context, descriptionController, child) {
            return CustomTextFormField(
              controller: controllerDescritpion,
              hintText: "Description de votre don ici".tr,
              maxLines: 5,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Saisir une description";
                }
                return null;
              }, // Grande zone de texte
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagesDonMateriel(BuildContext context) {
    return Consumer<ParticipationMaterielProvider>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Image illustative pour le don",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              height: 120.v,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  if (index < imageProvider.selectedImages.length) {
                    return Stack(
                      children: [
                        Image.file(
                          imageProvider.selectedImages[index],
                          width: 100.h,
                          height: 100.v,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => imageProvider.removeImage(index),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (index == imageProvider.selectedImages.length) {
                    return GestureDetector(
                      onTap: () => _pickImage(context),
                      child: Stack(
                        children: [
                          Container(
                            width: 100.h,
                            height: 100.v,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo_camera,
                                color: Colors.grey[500],
                                size: 50,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: 100.h,
                      height: 100.v,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.grey[500],
                          size: 60,
                        ),
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageProvider = context.read<ParticipationMaterielProvider>();
      imageProvider.addImage(File(pickedFile.path));
    }
  }

  Widget _buildValidDonMaterielButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          //recuperation des entrées utilisateur
          final provider = Provider.of<ParticipationMaterielProvider>(context,
              listen: false);
          String titre = controllerTitre.text;
          String description = controllerDescritpion.text;
          List<File> images = provider.selectedImages;

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
          Donmateriel donmateriel = Donmateriel(
              type: 'MATERIEL',
              declarationId: declarationId,
              donateurId: utilisateur.id!,
              titre: titre,
              description: description);
          try {
            bool savedDonMateriel = await Donmaterielservice()
                .saveDonMaterielwithImages(donmateriel, images);
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }
            if (savedDonMateriel == true) {
              String message =
                  "don envoyé, Merci beaucoup pour votre intervention.";
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
              String title = "Don Materiel Rejeté";
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
        } else
          print("Invalid");
      },
      height: 54.v,
      text: "Valider votre don".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
