import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Pret.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/participation_pret/provider/Participation_pret_provider.dart';
import 'package:terangaconnect/services/PretService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/ConfirmationDialog.dart';
import 'package:terangaconnect/widgets/RejectedDialog.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

class ParticipationPret extends StatelessWidget {
  late String declarationId;
  late Utilisateur utilisateur;
  ParticipationPret({required this.utilisateur, required this.declarationId});
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
                  _buildPretTitle(context),
                  SizedBox(height: 12.v),
                  _buildPretDescription(context),
                  SizedBox(height: 29.v),
                  _buildDureePret(context),
                  SizedBox(height: 29.v),
                  _buildImagesPret(context),
                  SizedBox(height: 29.v),
                  SizedBox(height: 21.v),
                  _buildValidPretButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPretTitle(BuildContext context) {
    return Selector<ParticipationPretProvider, TextEditingController?>(
      selector: (context, provider) => provider.titrePretController,
      builder: (context, articleController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 12.v),
                child: Text(
                  "Titre de votre pret".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            CustomTextFormField(
              controller: controllerTitre,
              hintText: "Titre de votre prêt".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "titre du prêt".tr;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPretDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description de ce pret ...",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<ParticipationPretProvider, TextEditingController?>(
          selector: (context, provider) => provider.descriptionPretController,
          builder: (context, descriptionController, child) {
            return CustomTextFormField(
              controller: controllerDescritpion,
              hintText: "Description de votre pret ici".tr,
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

  Widget _buildImagesPret(BuildContext context) {
    return Consumer<ParticipationPretProvider>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Image illustative",
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

  Widget _buildDureePret(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "La duree en nombre de jours",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<ParticipationPretProvider, TextEditingController?>(
          selector: (context, provider) => provider.dureeController,
          builder: (context, priceController, child) {
            return CustomTextFormField(
              controller: controllerDuree,
              textInputType: TextInputType.number,
              hintText: "Donner la durée pour votre pret".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "indiquer la durée".tr;
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageProvider = context.read<ParticipationPretProvider>();
      imageProvider.addImage(File(pickedFile.path));
    }
  }

  Widget _buildValidPretButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          //recuperation des entrées utilisateur
          final provider =
              Provider.of<ParticipationPretProvider>(context, listen: false);
          String titre = controllerTitre.text;
          String description = controllerDescritpion.text;
          List<File> images = provider.selectedImages;
          int duree = int.parse(controllerDuree.text);
          Pret pret = Pret(
              type: 'PRET',
              declarationId: declarationId,
              donateurId: utilisateur.id!,
              titre: titre,
              description: description,
              duree: duree);

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
            bool savedPret =
                await Pretservice().savePretwithImages(pret, images);
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }
            if (savedPret == true) {
              String message =
                  "pret envoyé, Merci beaucoup pour votre intervention.";
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
              String title = "Pret non envoyé";
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
      text: "Valider le pret".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
