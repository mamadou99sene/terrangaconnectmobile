import 'package:flutter/material.dart';
import 'package:terangaconnect/core/app_export.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  ConfirmationDialog({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.all(20.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60.0,
            ),
            SizedBox(height: 20.0),
            Text(
              text,
              style: theme.textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
