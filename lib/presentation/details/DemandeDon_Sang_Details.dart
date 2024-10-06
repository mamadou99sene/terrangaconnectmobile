import 'package:flutter/material.dart';
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/control/Control.dart';
import 'package:terangaconnect/models/DemandeDonSang.dart';
import 'package:terangaconnect/models/DonSang.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/participation_don_sang/Participation_don_sang.dart';
import 'package:terangaconnect/services/DonSangService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:terangaconnect/core/app_export.dart';

class DemandedonSangDetails extends StatefulWidget {
  late Demandedonsang demandedonsang;
  late Utilisateur utilisateur;
  DemandedonSangDetails(
      {required this.demandedonsang, required this.utilisateur});
  @override
  State<DemandedonSangDetails> createState() => _DemandedonSangDetailsState();
}

class _DemandedonSangDetailsState extends State<DemandedonSangDetails> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    List<String> images = widget.demandedonsang.images!
        .map((imageUrl) => API.URL + imageUrl.substring(22))
        .toList();
    print(images);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.demandedonsang.titre}"),
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
                        _buildImageDemande(context),
                        SizedBox(height: 10.h),
                        _buildSocialActions(context),
                        SizedBox(height: 8),
                        _buildUDemandeSangHeader(context),
                        SizedBox(height: 8),
                        _buildDemandeDetails(context),
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

  Widget _buildButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ParticipationDonSang(
                      declarationId: widget.demandedonsang.id!,
                      utilisateur: widget.utilisateur,
                    )));
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
                widget.demandedonsang.demandeur!.telephone,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        CustomElevatedButton(
          text: 'Contacter',
          onPressed: () => Control().launchWhatsApp(
              context, widget.demandedonsang.demandeur!.telephone),
          width: 100,
          height: 40,
          buttonStyle: CustomButtonStyles.fillPrimary,
        ),
      ],
    );
  }

  Widget _buildUDemandeSangHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.demandedonsang.titre,
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Text(
          "Classe Sang ${widget.demandedonsang.classe}",
          style: theme.textTheme.titleLarge!.copyWith(color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildImageDemande(BuildContext context) {
    List<String> images = widget.demandedonsang.images!
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
          icon: Icon(Icons.message, color: Colors.black54),
          onPressed: () => Control().launchWhatsApp(
              context, widget.demandedonsang.demandeur!.telephone),
        ),
        IconButton(
          icon: Icon(Icons.comment, color: Colors.black54),
          onPressed: () {
            // TODO: Implémenter la fonctionnalité de commentaire
          },
        ),
        IconButton(
          icon: Icon(Icons.volunteer_activism_sharp, color: Colors.black54),
          onPressed: () async {
            print('##############Don de sang########################');
            List<Donsang>? dons = await Donsangservice()
                .getAllDonSangByDeclarationId(widget.demandedonsang.id!);
            for (var d in dons!) {
              print(d.toJson());
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.black54),
          onPressed: () => Control().shareDemandedonsang(widget.demandedonsang),
        ),
      ],
    );
  }

  Widget _buildDemandeDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          children: [
            _buildChip(
                context, Icons.location_on, widget.demandedonsang.adresse),
            _buildChip(
              context,
              Icons.access_time,
              Control().getDurationString(DateTime.now()
                  .difference(widget.demandedonsang.datePublication!)),
            ),
            _buildChip(
                context, Icons.bloodtype_rounded, widget.demandedonsang.rhesus),
          ],
        ),
        SizedBox(height: 16),
        Text(
          widget.demandedonsang.description,
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
}
