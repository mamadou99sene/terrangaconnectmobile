import 'package:flutter/material.dart';
import 'package:terangaconnect/core/app_export.dart';

class Rejecteddialog extends StatelessWidget {
  String titre;
  String message;
  Rejecteddialog({required this.titre, required this.message});

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
              Text(
                titre.tr,
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                message.tr,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 45,
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Fonction pour afficher le dialogue
void showRejecteddialogDialog(
    BuildContext context, String titre, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Rejecteddialog(
        titre: titre,
        message: message,
      );
    },
  );

  // Ferme automatiquement le dialogue après 3 secondes
  Future.delayed(Duration(seconds: 3), () {
    Navigator.of(context).pop();
  });
}
