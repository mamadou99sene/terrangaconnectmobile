import 'package:flutter/material.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'package:terangaconnect/models/Evenement.dart';
import '../core/utils/image_constant.dart';
import '../theme/custom_text_style.dart';
import 'custom_elevated_button.dart';
import 'custom_image_view.dart';

class Evenementitem extends StatelessWidget {
  final Evenement evenement;

  const Evenementitem({Key? key, required this.evenement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = evenement.images![0];
    String subUrl = imageUrl.substring(22);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CustomImageView(
            fit: BoxFit.cover,
            imagePath: ImageConstant.imgEllipse6363,
            height: 40.adaptSize,
            width: 40.adaptSize,
            radius: BorderRadius.circular(20.h),
          ),
          title: Text(
            "${evenement.demandeur!.email}",
            style: CustomTextStyles.labelLargeErrorContainer,
          ),
          subtitle: Text(
            "${evenement.titre}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.labelLargeErrorContainer,
          ),
        ),
        Card(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CustomImageView(
              imagePath: "${API.URL}$subUrl",
              fit: BoxFit.cover,
              radius: BorderRadius.circular(10.h),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.watch_later, color: Colors.grey, size: 16),
                  SizedBox(width: 4.h),
                  Text(
                    "${evenement.datePublication!.minute} min",
                    style: CustomTextStyles.labelLargeErrorContainer,
                  ),
                ],
              ),
              CustomElevatedButton(
                height: 24.v,
                width: 60.h,
                text: "${evenement.type}",
                buttonTextStyle:
                    Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: evenement.type == 'Urgent'
                              ? Colors.red
                              : Colors.green,
                        ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.black, size: 16),
              SizedBox(width: 4.h),
              Expanded(
                child: Text(
                  "${evenement.lieu}",
                  style: CustomTextStyles.labelLargeErrorContainer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
