import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'package:terangaconnect/localization/app_localization.dart';
import 'package:terangaconnect/models/Evenement.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppDemandeDon.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/assistance/Assistance.dart';
import 'package:terangaconnect/presentation/details/Evenement_Details.dart';
import 'package:terangaconnect/services/EvenementService.dart';
import 'package:terangaconnect/theme/custom_text_style.dart';
import 'package:terangaconnect/theme/theme_helper.dart';
import 'package:terangaconnect/widgets/EventItemWithImages.dart';
import 'package:terangaconnect/widgets/MyDrawer.dart';
import 'package:terangaconnect/widgets/publication_button.dart';
import '../core/utils/image_constant.dart';
import '../widgets/app_bar/appbar_leading_image.dart';
import '../widgets/app_bar/appbar_title.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';

class AppEvent extends StatefulWidget {
  late Utilisateur utilisateur;
  AppEvent({required this.utilisateur});
  @override
  _AppEventState createState() => _AppEventState();
}

class _AppEventState extends State<AppEvent> {
  String selectedCategory = 'Événements';
  late List<Evenement> evenements = [];
  late List<Evenement> filterEvents = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  _filterEvents(String key) {
    setState(() {
      filterEvents = evenements
          .where(
              (event) => event.titre.toLowerCase().contains(key.toLowerCase()))
          .toList();
    });
  }

  Future<void> _loadEvenements() async {
    evenements = await Evenementservice().getAllEvents();
    filterEvents = evenements;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.v),
                _buildSearchBar(),
                Padding(
                  padding: EdgeInsets.only(left: 1.h, top: 10.h),
                  child: Text(
                    "lbl_ev_explorer".tr,
                    style: CustomTextStyles.titleMediumGray40002,
                  ),
                ),
                SizedBox(height: 6.v),
                FutureBuilder(
                  future: _loadEvenements(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitPumpingHeart(
                          color: Colors.green,
                        ),
                      );
                    } else {
                      return _buildItemsList(context, filterEvents);
                    }
                  },
                ),
                SizedBox(height: 20.v),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildBottomBar(context),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.h),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: searchController,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: "Rechercher un evenement...".tr,
          hintStyle: theme.textTheme.labelLarge,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Colors.grey[600]),
            onPressed: () => _filterEvents(searchController.text),
          ),
        ),
        onChanged: _filterEvents,
        style: theme.textTheme.headlineLarge,
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
                  border: Border.all(
                      color: Color(0xFFE0B589)), // Couleur sable doré
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      color: Color(0xFFB85C38), // Couleur terre de Sienne
                      size: 24.h,
                    ),
                    SizedBox(width: 5.h),
                    Text(
                      "Impact",
                      style: TextStyle(
                        color: Color(0xFF5C3D2E), // Couleur marron foncé
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
                                utilisateur: widget.utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Événements", Icons.event, () {
                  _loadEvenements();
                }),
                _buildBottomButtonIcon("Demande sang", Icons.favorite, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppDemandeDonSang(
                                utilisateur: widget.utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Assistance", Icons.assistant, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Assistance(
                                utilisateur: widget.utilisateur,
                              )));
                }),
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

  Widget buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        switch (type) {
          case BottomBarEnum.Explorer:
            // Naviguer vers la page d'exploration
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AppUrgence(
                          utilisateur: widget.utilisateur,
                        )));
            break;
          case BottomBarEnum.Publication:
            // Naviguer vers la page de publication
            showPublicationDialog(context, widget.utilisateur);
            break;
          case BottomBarEnum.MesAnnonces:
            // Naviguer vers la page des annonces de l'utilisateur
            break;
          case BottomBarEnum.MonProfil:
            // Naviguer vers la page de profil de l'utilisateur
            break;
        }
      },
    );
  }

/* 
  Widget _buildItemsList(BuildContext context, List<Evenement> evenements) {
    if (evenements.isEmpty) {
      return Center(child: Text("Aucun évènement trouvé"));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: evenements.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              // Naviguer vers la page de détails de l'élément
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EvenementDetails(evenement: evenements[index])));
            },
            child: Evenementitem(evenement: evenements[index]));
      },
    );
  } */
  Widget _buildItemsList(BuildContext context, List<Evenement> evenements) {
    if (evenements.isEmpty) {
      return Center(
          child: Text(
        "Aucun évènement trouvé",
        style: theme.textTheme.titleMedium,
      ));
    }
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey[200],
          thickness: 1.0,
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: evenements.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EvenementDetails(
                          evenement: evenements[index],
                          utilisateur: widget.utilisateur,
                        )));
          },
          child: Eventitemwithimages(evenement: evenements[index]),
        );
      },
    );
  }
}
