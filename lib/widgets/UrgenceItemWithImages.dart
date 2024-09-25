import 'package:flutter/material.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/control/Control.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import '../core/utils/image_constant.dart';
import '../theme/custom_text_style.dart';
import 'custom_elevated_button.dart';
import 'custom_image_view.dart';

class Urgenceitemwithimages extends StatelessWidget {
  final Urgencesociale urgence;

  const Urgenceitemwithimages({Key? key, required this.urgence})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: Container(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${urgence.demandeur!.email}",
                    style: CustomTextStyles.labelLargeErrorContainer,
                  ),
                  Text(
                    "il y'a ${Control().getDurationString(DateTime.now().difference(urgence.datePublication!))}",
                    style: CustomTextStyles.labelLargeErrorContainer,
                  ),
                ],
              ),
            ),
          ),
          subtitle: Text(
            "${urgence.titre}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.labelLargeErrorContainer,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.h, bottom: 10.h, right: 15.h),
          child: Text(
            "${urgence.description}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.labelLargeGray50001,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Card(child: _buildImageGallery()),
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                    size: 24.h,
                  ),
                  SizedBox(width: 4.h),
                  Text(
                    "requis ${urgence.montantRequis} FCFA",
                    style: CustomTextStyles.labelLargeErrorContainer,
                  ),
                ],
              ),
              CustomElevatedButton(
                height: 24.v,
                width: 60.h,
                text: "${urgence.type}",
                buttonStyle: ButtonStyle(),
                decoration: BoxDecoration(color: Colors.white),
                buttonTextStyle: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(
                        color: Colors.white,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600),
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
                  "${urgence.lieu}",
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

  Widget _buildImageGallery() {
    List<String> images = urgence.images!;
    if (images.isEmpty) return SizedBox.shrink();

    return Container(
      height: 200.h, // Adjust this value as needed
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildImage(images[0], true),
          ),
          if (images.length > 1)
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildImage(images[1], false)),
                  if (images.length > 2)
                    Expanded(child: _buildImage(images[2], false)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl, bool isMainImage) {
    String subUrl = imageUrl.substring(22);
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomImageView(
          imagePath: "${API.URL}$subUrl",
          fit: BoxFit.cover,
          radius: BorderRadius.circular(10.h),
        ),
      ],
    );
  }
}
