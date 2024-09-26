import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppDemandeDon.dart';
import 'package:terangaconnect/presentation/AppEvent.dart';
import 'package:terangaconnect/presentation/assistance/Assistance.dart';
import 'package:terangaconnect/presentation/details/Urgence_Details.dart';
import 'package:terangaconnect/presentation/mon_profile/Mon_Profile.dart';
import 'package:terangaconnect/services/UrgenceSocialeService.dart';
import 'package:terangaconnect/widgets/MyDrawer.dart';
import 'package:terangaconnect/widgets/UrgenceItemWithImages.dart';
import 'package:terangaconnect/widgets/publication_button.dart';
import '../widgets/app_bar/appbar_leading_image.dart';
import '../widgets/app_bar/appbar_title.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';

class AppUrgence extends StatefulWidget {
  late Utilisateur utilisateur;
  AppUrgence({required this.utilisateur});
  @override
  _AppUrgenceState createState() => _AppUrgenceState();
}

class _AppUrgenceState extends State<AppUrgence> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedCategory = 'Urgences';
  late List<Urgencesociale> allUrgences = [];
  late List<Urgencesociale> filteredUrgences = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadUrgences();
  }

  Future<void> _loadUrgences() async {
    allUrgences = await Urgencesocialeservice().getAllUrgenceSociales();
  }

  void _filterUrgences(String query) {
    setState(() {
      filteredUrgences = allUrgences
          .where((urgence) =>
              urgence.titre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                    "lbl_urg_explorer".tr,
                    style: CustomTextStyles.titleMediumGray40002,
                  ),
                ),
                SizedBox(height: 6.v),
                FutureBuilder(
                  future: _loadUrgences(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitPumpingHeart(
                          color: Colors.green,
                        ),
                      );
                    } else {
                      return _buildItemsList(context, allUrgences);
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
                  _loadUrgences();
                }),
                _buildBottomButtonIcon("Événements", Icons.event, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppEvent(
                                utilisateur: widget.utilisateur,
                              )));
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
          hintText: "Rechercher une urgence...".tr,
          hintStyle: theme.textTheme.labelLarge,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Colors.grey[600]),
            onPressed: () => _filterUrgences(searchController.text),
          ),
        ),
        onChanged: _filterUrgences,
        style: theme.textTheme.headlineLarge,
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

            break;
          case BottomBarEnum.Publication:
            showPublicationDialog(context, widget.utilisateur);
            break;
          case BottomBarEnum.MesAnnonces:
            // Naviguer vers la page des annonces de l'utilisateur

            break;
          case BottomBarEnum.MonProfil:
            // Naviguer vers la page de profil de l'utilisateur
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MonProfile(utilisateur: widget.utilisateur)));
            break;
        }
      },
    );
  }

  Widget _buildItemsList(BuildContext context, List<Urgencesociale> urgences) {
    if (urgences.isEmpty) {
      return Center(
          child: Text(
        "Aucune urgence trouvée",
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
      itemCount: urgences.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UrgenceDetails(
                          urgencesociale: urgences[index],
                          utilisateur: widget.utilisateur,
                        )));
          },
          child: Urgenceitemwithimages(urgence: urgences[index]),
        );
      },
    );
  }

  /* Widget _buildItemsList(BuildContext context, List<Urgencesociale> urgences) {
    if (urgences.isEmpty) {
      return Center(child: Text("Aucune urgence trouvée"));
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
      itemCount: urgences.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UrgenceDetails(urgencesociale: urgences[index])));
            },
            child: UrgenceSocialItem(urgencesociale: urgences[index]));
      },
    );
  } */
}
