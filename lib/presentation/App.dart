import 'package:flutter/material.dart';
import 'package:terangaconnect/core/utils/size_utils.dart';
import 'package:terangaconnect/localization/app_localization.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:terangaconnect/services/DemandeDonSangService.dart';
import 'package:terangaconnect/services/EvenementService.dart';
import 'package:terangaconnect/services/UrgenceSocialeService.dart';
import 'package:terangaconnect/theme/custom_text_style.dart';
import 'package:terangaconnect/widgets/MyDrawer.dart';
import 'package:terangaconnect/widgets/WidgetItem.dart';

import '../core/utils/image_constant.dart';
import '../widgets/app_bar/appbar_leading_image.dart';
import '../widgets/app_bar/appbar_title.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String selectedCategory = 'Urgences';
  List<dynamic> items = [];
  @override
  void initState() {
    super.initState();
    _loadUrgences();
  }

  Future<void> _loadUrgences() async {
    List<Urgencesociale> allUrgences =
        await Urgencesocialeservice().getAllUrgenceSociales();
    setState(() {
      items = allUrgences;
      selectedCategory = 'Urgences';
    });
  }

  Future<void> _loadEvenements() async {
    final evenements = await Evenementservice().getAllEvents();
    setState(() {
      items = evenements;
      selectedCategory = 'Événements';
    });
  }

  Future<void> _loadDonsSang() async {
    final donsSang = await Demandedonsangservice().getAllDemandeDonSang();
    setState(() {
      items = donsSang;
      selectedCategory = 'Dons';
    });
  }

  void _changeCategory(String category) {
    switch (category) {
      case 'Urgences':
        _loadUrgences();
        break;
      case 'Événements':
        _loadEvenements();
        break;
      case 'Dons':
        _loadDonsSang();
        break;
    }
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
                SizedBox(height: 26.v),
                Padding(
                  padding: EdgeInsets.only(left: 1.h),
                  child: Text(
                    "lbl_explorer".tr,
                    style: CustomTextStyles.headlineSmallGray900,
                  ),
                ),
                SizedBox(height: 6.v),
                _buildItemsList(context, items),
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
                  _changeCategory('Urgences');
                }),
                _buildBottomButtonIcon("Événements", Icons.event, () {
                  _changeCategory('Événements');
                }),
                _buildBottomButtonIcon("Dons", Icons.favorite, () {
                  _changeCategory('Dons');
                }),
                _buildBottomButtonIcon("Recherche", Icons.search, () {
                  setState(() {
                    selectedCategory = "Recherche";
                  });
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
            break;
          case BottomBarEnum.Publication:
            // Naviguer vers la page de publication
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

  Widget _buildItemsList(BuildContext context, List<dynamic> items) {
    if (items.isEmpty) {
      return Center(child: Text("Aucun élément trouvé"));
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
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Naviguer vers la page de détails de l'élément
          },
          child: WidgetItem(
            item: items[index],
            category: selectedCategory,
          ),
        );
      },
    );
  }
}

Future<List<String>> getDons() async {
  List<String> list = [];
  return list;
}
