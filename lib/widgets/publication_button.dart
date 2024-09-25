import 'package:flutter/material.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/publication_demande_don_sang/PublicationDemandeDonSang.dart';
import 'package:terangaconnect/presentation/publication_evenement/PublicationEvenement.dart';
import 'package:terangaconnect/presentation/publication_urgence/PublicationUrgence.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';

class PublicationWidget extends StatelessWidget {
  final Utilisateur utilisateur;

  const PublicationWidget({Key? key, required this.utilisateur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Que voulez-vous publier ?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge),
              SizedBox(height: 15),
              Text(
                "Choisissez le type de publication que vous souhaitez créer.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
              _buildPublishButton(
                context,
                "Urgence  ",
                Icons.warning_amber_outlined,
                () => _navigateTo(
                    context, Publicationurgence(utilisateur: utilisateur)),
              ),
              SizedBox(height: 10),
              _buildPublishButton(
                context,
                "Demande de don de sang ",
                Icons.bloodtype_outlined,
                () => _navigateTo(context,
                    Publicationdemandedonsang(utilisateur: utilisateur)),
              ),
              SizedBox(height: 10),
              _buildPublishButton(
                context,
                "Événement ",
                Icons.event_outlined,
                () => _navigateTo(
                    context, Publicationevenement(utilisateur: utilisateur)),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 45,
            child: CustomImageView(
              imagePath: ImageConstant.imageTeranga,
              height: 76.v,
              width: 87.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButton(
    BuildContext context,
    String text,
    IconData iconData,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: CustomElevatedButton(
        height: 44.v,
        text: text.tr,
        buttonStyle: CustomButtonStyles.fillPrimary,
        rightIcon: Icon(
          iconData,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

// Fonction pour afficher le dialogue
void showPublicationDialog(BuildContext context, Utilisateur utilisateur) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return PublicationWidget(utilisateur: utilisateur);
    },
  );
}
