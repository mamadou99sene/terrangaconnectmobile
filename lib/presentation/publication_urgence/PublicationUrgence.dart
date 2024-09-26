import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/publication_urgence/provider/PublicationUrgenceProvider.dart';
import 'package:terangaconnect/services/UrgenceSocialeService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/ConfirmationDialog.dart';
import 'package:terangaconnect/widgets/RejectedDialog.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

class Publicationurgence extends StatelessWidget {
  late Utilisateur utilisateur;
  Publicationurgence({required this.utilisateur});
  TextEditingController controllerTitre = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerMontant = TextEditingController();
  TextEditingController controllerLieu = TextEditingController();
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
                    "pbl_urg_social".tr,
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 43.v),
                  _buildAUrgenceSocialeTitle(context),
                  SizedBox(height: 12.v),
                  _buildDescriptionUrgence(context),
                  SizedBox(height: 29.v),
                  _buildLocalite(context),
                  SizedBox(height: 12.v),
                  _buildMontantRequis(context),
                  SizedBox(height: 29.v),
                  _buildTypeUrgence(context),
                  SizedBox(height: 29.v),
                  _buildImagesUploader(context),
                  SizedBox(height: 29.v),
                  SizedBox(height: 21.v),
                  _buildPublishUrgenceButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAUrgenceSocialeTitle(BuildContext context) {
    return Selector<Publicationurgenceprovider, TextEditingController?>(
      selector: (context, provider) => provider.titreUrgenceController,
      builder: (context, articleController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 12.v),
                child: Text(
                  "Titre de l'article".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            CustomTextFormField(
              controller: controllerTitre,
              hintText: "Titre de l'article".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "dnr_titr".tr;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDescriptionUrgence(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description de l'urgence sociale ...",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationurgenceprovider, TextEditingController?>(
          selector: (context, provider) =>
              provider.descriptionUrgenceController,
          builder: (context, descriptionController, child) {
            return CustomTextFormField(
              controller: controllerDescription,
              hintText: "Description de l'urgence sociale ici".tr,
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

  Widget _buildLocalite(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lieu de l'urgence",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationurgenceprovider, TextEditingController?>(
          selector: (context, provider) => provider.lieuUrgenceController,
          builder: (context, localiteController, child) {
            return CustomTextFormField(
              controller: controllerLieu,
              hintText: "Entrer la localité ou se trouve l'urgence".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "lieu_urg".tr;
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMontantRequis(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Montant requis",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationurgenceprovider, TextEditingController?>(
          selector: (context, provider) => provider.montantRequisController,
          builder: (context, priceController, child) {
            return CustomTextFormField(
              controller: controllerMontant,
              textInputType: TextInputType.number,
              hintText: "Donner le montant requis pour cette urgence".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "mnt_req".tr;
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagesUploader(BuildContext context) {
    return Consumer<Publicationurgenceprovider>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Image de l'urgence sociale",
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

  Widget _buildTypeUrgence(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Type de l'urgence",
        //   style: TextStyle(fontWeight: FontWeight.w500),
        // ),
        Selector<Publicationurgenceprovider, String?>(
          selector: (context, provider) => provider.getTypeUrgence,
          builder: (context, selectedTypeAnnonce, child) {
            return DropdownButtonFormField<String>(
              icon: Icon(
                Icons.heart_broken,
                color: Colors.green,
              ),
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                  label: Text(
                    "Selectionner le type",
                    style: TextStyle(fontSize: 15),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10))),
              value: selectedTypeAnnonce,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              hint: Text("Sélectionner le type d'annonce"),
              onChanged: (String? newValue) {
                context
                    .read<Publicationurgenceprovider>()
                    .setTypeAnnonce(newValue!);
              },
              items: <String>[
                'MALADE',
                'INSCRIPTION ETUDIANT',
                'SINISTRE',
                'AUTRE'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
      final imageProvider = context.read<Publicationurgenceprovider>();
      imageProvider.addImage(File(pickedFile.path));
    }
  }

  Widget _buildPublishUrgenceButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final provider =
              Provider.of<Publicationurgenceprovider>(context, listen: false);
          String titre = controllerTitre.text;
          String description = controllerDescription.text;
          double montant = double.parse(controllerMontant.text);
          String lieu = controllerLieu.text;
          String type = provider.getTypeUrgence!;
          List<File> images = provider.selectedImages;

          Urgencesociale urgence = Urgencesociale(
              titre: titre,
              description: description,
              demandeurId: utilisateur.id!,
              lieu: lieu,
              type: type,
              montantRequis: montant);

          // Utilisez un BuildContext séparé pour les dialogues
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
            bool? savedurgence = await Urgencesocialeservice()
                .saveUrgenceSociale(urgence, images);

            // Assurez-vous que le contexte du dialogue est toujours valide avant de le fermer
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }

            if (savedurgence == true) {
              String message =
                  "Urgence envoyée, un moderateur vous contactera pour la validation.";
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
              String title = "Publication non envoyée";
              String message = "Merci de ressayer !!!";
              showRejecteddialogDialog(context, title, message);
            }
          } catch (e) {
            // Assurez-vous que le contexte du dialogue est toujours valide avant de le fermer
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
            }

            if (e.toString().contains("MaxUploadSizeExceededException")) {
              showRejecteddialogDialog(context, "Taille d'image excessive",
                  "La taille totale des images dépasse la limite autorisée. Veuillez réduire le nombre ou la taille des images.");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Erreur de connexion. Veuillez réessayer.")));
            }
          }
        } else {
          print("Invalid");
        }
      },
      height: 54.v,
      text: "Publier l'urgence".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
