import 'package:flutter/material.dart';

import '../theme/custom_button_style.dart';
import 'custom_elevated_button.dart';

class RejectedDialog extends StatelessWidget {
  final VoidCallback onclick;
  late String text;

  RejectedDialog({required this.onclick, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 60.0,
          ),
          SizedBox(height: 20.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          CustomElevatedButton(
            onPressed: onclick,
            text: text,
            height: 44,
            buttonStyle: CustomButtonStyles.fillPrimary,
          )
        ],
      ),
    );
  }
}
