import 'package:flutter/material.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'package:terangaconnect/localization/app_localization.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';

void showUrgenceParticipationDialog(
    BuildContext context, Urgencesociale urgence) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
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
                children: [
                  Text(
                    'Comment souhaitez-vous participer ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _buildParticipationButton(context, 'Don en espèces',
                      Icons.monetization_on_outlined, () {}),
                  SizedBox(height: 10),
                  _buildParticipationButton(context, 'Don de matériel',
                      Icons.inventory_outlined, () {}),
                  SizedBox(height: 10),
                  _buildParticipationButton(
                      context, 'Prêt de bien', Icons.home_outlined, () {}),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 45,
                child: Icon(
                  Icons.volunteer_activism,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildParticipationButton(
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
