import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/publication_evenement/provider/PublicationEvenementProvider.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/widgets/custom_text_form_field.dart';

// ignore: must_be_immutable
class Publicationevenement extends StatelessWidget {
  late Utilisateur utilisateur;
  Publicationevenement({required this.utilisateur});
  TextEditingController controllerTitre = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerLieu = TextEditingController();
  TextEditingController controllerStartDate = TextEditingController();
  TextEditingController controllerEndDate = TextEditingController();
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
                    "pbl_event".tr,
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 43.v),
                  _buildEventTitle(context),
                  SizedBox(height: 12.v),
                  _buildEventDescription(context),
                  SizedBox(height: 29.v),
                  _buildEventLocalite(context),
                  SizedBox(height: 29.v),
                  _buildEventStartDate(context),
                  SizedBox(height: 29.v),
                  _buildEventEndDate(context),
                  SizedBox(height: 29.v),
                  _buildTypeEvent(context),
                  SizedBox(height: 29.v),
                  _buildImagesEvent(context),
                  SizedBox(height: 29.v),
                  SizedBox(height: 21.v),
                  _buildPublishEventButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTitle(BuildContext context) {
    return Selector<Publicationevenementprovider, TextEditingController?>(
      selector: (context, provider) => provider.titreEventController,
      builder: (context, articleController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 12.v),
                child: Text(
                  "Titre de l'evenement".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            CustomTextFormField(
              controller: controllerTitre,
              hintText: "Titre de l'evenement".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "event_titr".tr;
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description de l'evenement ...",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationevenementprovider, TextEditingController?>(
          selector: (context, provider) => provider.descriptionEventController,
          builder: (context, descriptionController, child) {
            return CustomTextFormField(
              controller: descriptionController,
              hintText: "Description de l'evenement ici".tr,
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

  Widget _buildEventLocalite(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lieu de l'evenement",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationevenementprovider, TextEditingController?>(
          selector: (context, provider) => provider.lieuEventController,
          builder: (context, localiteController, child) {
            return CustomTextFormField(
              controller: controllerLieu,
              hintText: "Entrer la localité ou se deroulera l'evenement".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "lieu_event".tr;
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagesEvent(BuildContext context) {
    return Consumer<Publicationevenementprovider>(
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

  Widget _buildTypeEvent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Type de l'urgence",
        //   style: TextStyle(fontWeight: FontWeight.w500),
        // ),
        Selector<Publicationevenementprovider, String?>(
          selector: (context, provider) => provider.getTypeEvent,
          builder: (context, selectedTypeAnnonce, child) {
            return DropdownButtonFormField<String>(
              icon: Icon(
                Icons.event_sharp,
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
              hint: Text("Sélectionner le type d'evenement"),
              onChanged: (String? newValue) {
                context
                    .read<Publicationevenementprovider>()
                    .setTypeAnnonce(newValue!);
              },
              items: <String>[
                'CONFERENCE',
                'GRADUATION',
                'CAMPAGNE DON SANG',
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

  Widget _buildEventStartDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "debut de l'evenement".tr,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationevenementprovider, TextEditingController?>(
          selector: (context, provider) => provider.startDateController,
          builder: (context, dateOfBirthInputController, child) {
            return CustomTextFormField(
              isDateField: true,
              controller: controllerStartDate,
              hintText: "date de debut de l'evenement".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'la date !';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventEndDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "date de fin de l'evenement".tr,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Selector<Publicationevenementprovider, TextEditingController?>(
          selector: (context, provider) => provider.endDateController,
          builder: (context, dateOfBirthInputController, child) {
            return CustomTextFormField(
              isDateField: true,
              controller: controllerEndDate,
              hintText: "date de fin de l'evenement".tr,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Donner une date';
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
      final imageProvider = context.read<Publicationevenementprovider>();
      imageProvider.addImage(File(pickedFile.path));
    }
  }

  Widget _buildPublishEventButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          //recuperation des entrées utilisateur
          final provider =
              Provider.of<Publicationevenementprovider>(context, listen: false);
          String titre = controllerTitre.text;
          String description = controllerDescription.text;
          String lieu = controllerLieu.text;
          String type = provider.getTypeEvent!;
          List<File> images = provider.selectedImages;
          //instanciation objet

          print(type);
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
      text: "Publier l'evenement".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
