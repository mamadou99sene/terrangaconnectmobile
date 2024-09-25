import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/mon_profile/provider/MonProfileProvider.dart';
import 'package:terangaconnect/widgets/custom_bottom_bar.dart';

import '../../core/app_export.dart';

class MonProfile extends StatelessWidget {
  final Utilisateur utilisateur;

  MonProfile({required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Monprofileprovider(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mon profil', style: TextStyle(color: Colors.green)),
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileHeader(
                  utilisateur: utilisateur,
                ),
                SizedBox(height: 20),
                UploaderCard(
                  utilisateur: utilisateur,
                  ontap: () {},
                ),
                SizedBox(height: 20),
                ActionList(
                  utilisateur: utilisateur,
                ),
                Spacer(),
                LogoutButton(
                  onTap: () async {},
                ),
              ],
            ),
          ),
          bottomNavigationBar: buildBottomBar(context),
        ),
      ),
    );
  }

  Widget buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        switch (type) {
          case BottomBarEnum.Explorer:
            break;
          case BottomBarEnum.Publication:
            break;
          case BottomBarEnum.MesAnnonces:
            break;
          case BottomBarEnum.MonProfil:
            break;
          default:
            print("Type non pris en charge");
        }
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final Utilisateur utilisateur;
  
  ProfileHeader({required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Consumer<Monprofileprovider>(
      builder: (context, imageNotifier, child) {
        if (imageNotifier.utilisateur == null) {
          imageNotifier.loadProfileImage(utilisateur);
        }

        return Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    if (imageNotifier.isLoading)
                      SpinKitFadingCircle(color: Colors.green)
                    else if (imageNotifier.profileImage == null)
                      CustomImageView(
                        fit: BoxFit.cover,
                        imagePath: ImageConstant.imgEllipse6363,
                        height: 80.adaptSize,
                        width: 80.adaptSize,
                        radius: BorderRadius.circular(40.h),
                      )
                    else
                      CircleAvatar(
                        radius: 40.h,
                        backgroundImage: MemoryImage(imageNotifier.profileImage!),
                      ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () => _showImageSourceActionSheet(context, imageNotifier),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${imageNotifier.utilisateur?.email ?? utilisateur.email}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineLarge,
                      ),
                      Text(
                        imageNotifier.utilisateur?.telephone ?? utilisateur.telephone,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (imageNotifier.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  imageNotifier.error!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showImageSourceActionSheet(BuildContext context, Monprofileprovider imageNotifier) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  imageNotifier.pickAndSaveImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  imageNotifier.pickAndSaveImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
class UploaderCard extends StatelessWidget {
  late Utilisateur utilisateur;
  VoidCallback ontap;
  UploaderCard({required this.ontap, required this.utilisateur});
  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(Icons.image, color: Colors.green),
          title: Text('changer votre profile',
              style: theme.textTheme.displayLarge),
          subtitle: Row(
            children: [
              Text(
                  'Score: ${(utilisateur.score == null ? 0 : utilisateur.score)}',
                  style: theme.textTheme.headlineLarge),
            ],
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: ontap,
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ));
  }
}

class ActionList extends StatelessWidget {
  late Utilisateur utilisateur;
  ActionList({required this.utilisateur});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionItem(icon: Icons.campaign, title: 'Mes Publications', count: 2),
        SizedBox(height: 10),
        ActionItem(
            icon: Icons.shopping_cart, title: 'Mes achats/demandes', count: 2),
        SizedBox(height: 10),
        ActionItem(
          icon: Icons.subscriptions,
          title: 'Mes abonnements',
          count: 1,
        ),
      ],
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;

  ActionItem({required this.icon, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text('$count',
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  VoidCallback onTap;
  LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text('Se déconnecter',
          style: TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }
}

Future<void> _pickImage(BuildContext context) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {}
}
