import 'package:flutter/material.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'theme_helper.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillErrorContainer => BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.5),
      );
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
// Gradient decorations
  static BoxDecoration get gradientGrayToErrorContainer => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, -0.06),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.gray80099,
            theme.colorScheme.errorContainer.withOpacity(1)
          ],
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder13 => BorderRadius.circular(
        13.h,
      );
// Rounded borders
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );
}
