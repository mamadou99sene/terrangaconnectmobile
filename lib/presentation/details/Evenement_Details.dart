import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/control/Control.dart';
import 'package:terangaconnect/models/Evenement.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/core/app_export.dart';

class EvenementDetails extends StatefulWidget {
  late Evenement evenement;
  EvenementDetails({required this.evenement});
  @override
  State<EvenementDetails> createState() => _EvenementState();
}

class _EvenementState extends State<EvenementDetails> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.evenement.titre}"),
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
                        _buildImageEvent(),
                        SizedBox(height: 10.h),
                        _buildSocialActions(),
                        SizedBox(height: 8),
                        _buildEventHeader(context),
                        SizedBox(height: 8),
                        _buildEventDetails(context),
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
                    child: _buildButton(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageEvent() {
    List<String> images = widget.evenement.images!
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

  Widget _buildSocialActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.message, color: Colors.green),
          onPressed: () => Control()
              .launchWhatsApp(context, widget.evenement.demandeur!.telephone),
        ),
        IconButton(
          icon: Icon(Icons.comment, color: Colors.blue),
          onPressed: () {
            // TODO: Implémenter la fonctionnalité de commentaire
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.orange),
          onPressed: () => Control().shareEvent,
        ),
      ],
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          children: [
            _buildChip(context, Icons.location_on, widget.evenement.lieu),
            _buildChip(
              context,
              Icons.access_time,
              (widget.evenement.dateDebut.difference(DateTime.now()) >
                      Duration.zero
                  ? "dans " +
                      Control().getDurationString(
                          widget.evenement.dateDebut.difference(DateTime.now()))
                  : Control().getDurationString(
                      widget.evenement.dateDebut.difference(DateTime.now()))),
            ),
            _buildChip(context, null, widget.evenement.type),
          ],
        ),
        SizedBox(height: 16),
        Text(
          widget.evenement.description,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildEventHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.evenement.titre,
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.star_rate,
              color: Colors.yellow,
            ),
            Text(" du ${Control().formatDate(widget.evenement.dateDebut)}",
                style: theme.textTheme.headlineLarge),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.expand_circle_down,
              color: Colors.red,
            ),
            Text(" au ${Control().formatDate(widget.evenement.dateFin)}",
                style: theme.textTheme.headlineLarge),
          ],
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

  Widget _buildButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
                child: SpinKitCircle(
              color: Colors.green,
              size: 50,
            ));
          },
        );
        try {
          //instaciation
          Navigator.of(context).pop();
        } catch (e) {
          Navigator.of(context).pop();

          // Afficher une erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur de connexion !!! Retentez")),
          );
        }
      },
      height: 54.v,
      isDisabled: false,
      text: "Participer".tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
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
                widget.evenement.demandeur!.telephone,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        CustomElevatedButton(
          text: 'Contacter',
          onPressed: () => Control()
              .launchWhatsApp(context, widget.evenement.demandeur!.telephone),
          width: 100,
          height: 40,
          buttonStyle: CustomButtonStyles.fillPrimary,
        ),
      ],
    );
  }
}
