import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/control/Control.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/widgets/participation_widget.dart';

class UrgenceDetails extends StatefulWidget {
  final Urgencesociale urgencesociale;
  UrgenceDetails({required this.urgencesociale});

  @override
  State<UrgenceDetails> createState() => _UrgenceDetailsState();
}

class _UrgenceDetailsState extends State<UrgenceDetails> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.urgencesociale.titre}"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageCarousel(context),
                        SizedBox(height: 10.h),
                        _buildSocialActions(context),
                        SizedBox(height: 8),
                        _buildUrgenceHeader(context),
                        SizedBox(height: 8),
                        _buildUrgenceDetails(context),
                        SizedBox(height: 16),
                        SizedBox(height: 16),
                        _buildDemandeurInfo(context),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildButtonParticipation(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    List<String> images = widget.urgencesociale.images!
        .map((imageUrl) => API.URL + imageUrl.substring(22))
        .toList();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => CustomImageView(
                fit: BoxFit.cover,
                imagePath: images[index],
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                radius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 10 : 8,
                height: _currentPage == index ? 10 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.green : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.message, color: Colors.green),
          onPressed: () => Control().launchWhatsApp(
              context, widget.urgencesociale.demandeur!.telephone),
        ),
        IconButton(
          icon: Icon(Icons.comment, color: Colors.blue),
          onPressed: () {
            // TODO: Implémenter la fonctionnalité de commentaire
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.orange),
          onPressed: () => Control().shareUrgence(widget.urgencesociale),
        ),
      ],
    );
  }

  Widget _buildUrgenceHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.urgencesociale.titre,
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Text(
          "Montant requis : ${widget.urgencesociale.montantRequis} Fcfa",
          style: theme.textTheme.titleMedium!.copyWith(color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildUrgenceDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          children: [
            _buildChip(context, Icons.location_on, widget.urgencesociale.lieu),
            _buildChip(
              context,
              Icons.access_time,
              Control().getDurationString(DateTime.now()
                  .difference(widget.urgencesociale.datePublication!)),
            ),
            _buildChip(context, null, widget.urgencesociale.type),
          ],
        ),
        SizedBox(height: 16),
        Text(
          widget.urgencesociale.description,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, IconData? icon, String label) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
    );
  }

  Widget _buildDemandeurInfo(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgEllipse6363,
          height: 40,
          width: 40,
          radius: BorderRadius.circular(20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Demandeur",
                style: theme.textTheme.titleSmall,
              ),
              Text(
                widget.urgencesociale.demandeur!.telephone,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        CustomElevatedButton(
          text: 'Contacter',
          onPressed: () => Control().launchWhatsApp(
              context, widget.urgencesociale.demandeur!.telephone),
          width: 100,
          height: 40,
          buttonStyle: CustomButtonStyles.fillPrimary,
        ),
      ],
    );
  }

  Widget _buildButtonParticipation(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () {
        showUrgenceParticipationDialog(context, widget.urgencesociale);
      },
      height: 54.v,
      isDisabled: false,
      text: "Participer".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
    );
  }
}
