import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/DemandeDonSang.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/publication_demande_don_sang/provider/PublicationDemandeDonSangProvider.dart';
import 'package:terangaconnect/services/DemandeDonSangService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/ConfirmationDialog.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

// ignore: must_be_immutable
class Publicationdemandedonsang extends StatelessWidget {
  late Utilisateur utilisateur;
  Publicationdemandedonsang({required this.utilisateur});
  TextEditingController controllerTitre = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerAdresse = TextEditingController();
  TextEditingController controllerClasse = TextEditingController();
  TextEditingController controllerRhesus = TextEditingController();
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
                    "pbl_dmnd".tr,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 43.v),
                  _buildDemandeDonSangTitle(context),
                  SizedBox(height: 12.v),
                  _buildDemandedonsangDescription(context),
                  SizedBox(height: 29.v),
                  _buildDemandeDonSangAdresse(context),
                  SizedBox(height: 29.v),
                  _buildClasseDemandedonSang(context),
                  SizedBox(height: 29.v),
                  _buildRhesusDemandedonSang(context),
                  SizedBox(height: 29.v),
                  _buildImagesDemandedonSang(context),
                  SizedBox(height: 29.v),
                  SizedBox(height: 21.v),
                  _buildPublishDemandeButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemandeDonSangTitle(BuildContext context) {
    return Selector<Publicationdemandedonsangprovider, TextEditingController?>(
      selector: (context, provider) => provider.titreEventController,
      builder: (context, articleController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 12.v),
                child: Text(
                  "Titre de la demande".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            CustomTextFormField(
              controller: controllerTitre,
              hintText: "Titre de la demande".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "dmnd_ttl".tr;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDemandedonsangDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description de la demande de sang ...",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationdemandedonsangprovider, TextEditingController?>(
          selector: (context, provider) => provider.descriptionEventController,
          builder: (context, descriptionController, child) {
            return CustomTextFormField(
              controller: descriptionController,
              hintText: "Description de la demande".tr,
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

  Widget _buildDemandeDonSangAdresse(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adresse du bénéficiaire",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationdemandedonsangprovider, TextEditingController?>(
          selector: (context, provider) => provider.adresseEventController,
          builder: (context, localiteController, child) {
            return CustomTextFormField(
              controller: controllerAdresse,
              hintText: "adrs_bnf".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "adrs".tr;
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagesDemandedonSang(BuildContext context) {
    return Consumer<Publicationdemandedonsangprovider>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Image de preuve",
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

  Widget _buildClasseDemandedonSang(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Type de l'urgence",
        //   style: TextStyle(fontWeight: FontWeight.w500),
        // ),
        Selector<Publicationdemandedonsangprovider, String?>(
          selector: (context, provider) => provider.getClasse,
          builder: (context, selectedTypeAnnonce, child) {
            return DropdownButtonFormField<String>(
              icon: Icon(
                Icons.bloodtype_rounded,
                color: Colors.red,
              ),
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                  label: Text(
                    "Selectionner la classe de sang",
                    style: TextStyle(fontSize: 15),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10))),
              value: selectedTypeAnnonce,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              hint: Text("Sélectionner la classe à demander"),
              onChanged: (String? newValue) {
                context
                    .read<Publicationdemandedonsangprovider>()
                    .setClasse(newValue!);
              },
              items: <String>['A', 'B', 'AB', 'O']
                  .map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildRhesusDemandedonSang(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<Publicationdemandedonsangprovider, String?>(
          selector: (context, provider) => provider.getRhesus(),
          builder: (context, selectedTypeAnnonce, child) {
            return DropdownButtonFormField<String>(
              icon: Icon(
                Icons.post_add_outlined,
                color: Colors.red,
              ),
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                  label: Text(
                    "Selectionner le rhesus",
                    style: TextStyle(fontSize: 15),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10))),
              value: selectedTypeAnnonce,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              hint: Text("Sélectionner le rhésus"),
              onChanged: (String? newValue) {
                context
                    .read<Publicationdemandedonsangprovider>()
                    .setRhesus(newValue!);
              },
              items: <String>['POSITIF', 'NEGATIF']
                  .map<DropdownMenuItem<String>>((String value) {
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
      final imageProvider = context.read<Publicationdemandedonsangprovider>();
      imageProvider.addImage(File(pickedFile.path));
    }
  }

  Widget _buildPublishDemandeButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          //recuperation des entrées utilisateur
          final provider = Provider.of<Publicationdemandedonsangprovider>(
              context,
              listen: false);
          String titre = controllerTitre.text;
          String description = controllerDescription.text;
          String adresse = controllerAdresse.text;
          String classe = provider.getClasse!;
          String rhesus = provider.getRhesus()!;
          List<File> images = provider.selectedImages;
          //instanciation objet
          Demandedonsang demande = Demandedonsang(
              titre: titre,
              description: description,
              demandeurId: utilisateur.id!,
              adresse: adresse,
              classe: classe,
              rhesus: rhesus);
          print(classe);
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
            //appel service
            // bool saved = await Demandedonsangservice()
            //     .saveDemandedonSang(demande, images);
            bool saved = true;
            if (saved == true) {
              showConfirmationDialog(context);
            }
            // Afficher une erreur
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Impossible d'envoyer votre demande !!",
                style: theme.textTheme.titleMedium,
              ),
            ));
            Navigator.of(context).pop();
          } catch (e) {
            Navigator.of(context).pop();

            // Afficher une erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur de connexion !!! Retentez")),
            );
          }
        } else
          print("Invalid");
      },
      height: 54.v,
      text: "Publier la demande".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}

void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        text:
            "demande envoyée, un modérateur vous contactera pour la validation de votre demande",
        onTap: () {
          Navigator.of(context).pop(true);
          //route
        },
      );
    },
  );
}
