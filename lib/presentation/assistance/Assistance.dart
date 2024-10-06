import 'package:flutter/material.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppDemandeDon.dart';
import 'package:terangaconnect/presentation/AppEvent.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/widgets/app_bar/appbar_leading_image.dart';
import 'package:terangaconnect/widgets/app_bar/appbar_title.dart';
import 'package:terangaconnect/widgets/app_bar/custom_app_bar.dart';

class Assistance extends StatelessWidget {
  late Utilisateur utilisateur;
  Assistance({required this.utilisateur});
  String selectedCategory = 'Assistance';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Important pour éviter l'overflow quand le clavier apparaît
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          _buildMessages(),
                        ],
                      ),
                    ),
                  ),
                  _buildMessageInput(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return Column(
      children: [
        _buildMessageItem(
            "Je souhaite avoir des informations par rapport a la plateforme teranga connect",
            "il y a 3 minutes",
            isUserMessage: true),
        _buildMessageItem(
            "Teranga connect est une plateforme communautaire Sénégalaise qui met en avant l'aspect de la hospitalité profondement ancrée dans l'esprit des sénégalais. Cette plateforme vous permet de declararer des urgences sociales, a savoir des malades, des etudiants n'ayant pas de moyen pour s'inscrire, des evemenements.... Et permet aux utilisateurs d'apporter leurs interventions",
            "il y a 3 minutes",
            isUserMessage: false),
      ],
    );
  }

  Widget _buildMessageItem(String text, String time,
      {required bool isUserMessage}) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Rédiger votre message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black54,
            ),
            onPressed: () {
              // ici la logique pour envoyer le message
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(150.0),
      child: Column(
        children: [
          CustomAppBar(
            leadingWidth: 78.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imageTeranga,
              margin: EdgeInsets.only(
                left: 30.h,
                top: 9.v,
                bottom: 4.v,
              ),
            ),
            title: AppbarTitle(
              text: "Teranga Connect",
              margin: EdgeInsets.only(left: 10.h),
            ),
            actions: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.1,
                margin: EdgeInsets.symmetric(vertical: 5.v),
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.h),
                  border: Border.all(color: Color(0xFFE0B589)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      color: Color(0xFFB85C38),
                      size: 24.h,
                    ),
                    SizedBox(width: 5.h),
                    Text(
                      "Impact",
                      style: TextStyle(
                        color: Color(0xFF5C3D2E),
                        fontSize: 16.v,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.v),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomButtonIcon("Urgences", Icons.warning, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppUrgence(
                                utilisateur: utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Événements", Icons.event, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppEvent(
                                utilisateur: utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Demande sang", Icons.favorite, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppDemandeDonSang(
                                utilisateur: utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Assistance", Icons.assistant, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtonIcon(
      String label, IconData icon, VoidCallback onPressed) {
    final isSelected = selectedCategory == label;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color:
                isSelected ? Color.fromARGB(255, 1, 250, 26) : Colors.grey[500],
            size: 24.h,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            color:
                isSelected ? Color.fromARGB(255, 1, 250, 26) : Colors.grey[500],
            fontSize: 12.v,
          ),
        ),
      ],
    );
  }
}
