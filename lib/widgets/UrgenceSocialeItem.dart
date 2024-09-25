import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:terangaconnect/services/UrgenceSocialeService.dart';
import '../core/utils/image_constant.dart';
import '../theme/custom_text_style.dart';
import 'custom_elevated_button.dart';
import 'custom_image_view.dart';

class UrgenceSocialItem extends StatelessWidget {
  late Urgencesociale urgencesociale;
  UrgenceSocialItem({required this.urgencesociale});
  @override
  Widget build(BuildContext context) {
    String imageUrl = urgencesociale.images![0];
    String subUrl = imageUrl.substring(22);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future:
                  Urgencesocialeservice().getUrgenceSocialeById(urgencesociale),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(
                    color: Colors.green,
                    size: 20,
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                      child: SpinKitCircle(
                    color: Colors.green,
                    size: 10,
                  ));
                } else {
                  return Row(
                    children: [
                      CustomImageView(
                        fit: BoxFit.cover,
                        imagePath: ImageConstant.imgEllipse6363,
                        height: 20.adaptSize,
                        width: 20.adaptSize,
                        radius: BorderRadius.circular(10.h),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 8.h, top: 2.v, bottom: 2.v),
                          child: Text(
                            "${urgencesociale.demandeur!.email}",
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.labelLargeErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 4.v),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomImageView(
                    imagePath: "${API.URL}$subUrl",
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(10.h),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.watch_later,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 4.h),
                              Text(
                                "${urgencesociale.datePublication!.minute}",
                                style: CustomTextStyles.labelLargeErrorContainer
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          CustomElevatedButton(
                            height: 24.v,
                            width: 60.h,
                            text: "${urgencesociale.montantRequis}",
                            buttonTextStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: 'couleur' == 0 ? Colors.green : null,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.v),
            Text(
              "${urgencesociale.titre}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.labelLargeErrorContainer,
            ),
            SizedBox(height: 5.v),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black, size: 16),
                SizedBox(width: 4.h),
                Text("${urgencesociale.lieu}",
                    style: CustomTextStyles.labelLargeErrorContainer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
