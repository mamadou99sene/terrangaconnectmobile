import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/presentation/connexion/Connexion.dart';
import 'package:terangaconnect/presentation/connexion/provider/ConnexionProvider.dart';
import 'package:terangaconnect/presentation/inscription/Inscription.dart';
import 'package:terangaconnect/presentation/inscription/provider/InscriptionProvider.dart';
import 'package:terangaconnect/presentation/participation_don_sang/provider/Participation_don_sang_provider.dart';
import 'package:terangaconnect/presentation/participation_materiel/provider/Participation_Materiel_Provider.dart';
import 'package:terangaconnect/presentation/participation_pret/provider/Participation_pret_provider.dart';
import 'package:terangaconnect/presentation/publication_demande_don_sang/PublicationDemandeDonSang.dart';
import 'package:terangaconnect/presentation/publication_demande_don_sang/provider/PublicationDemandeDonSangProvider.dart';
import 'package:terangaconnect/presentation/publication_evenement/PublicationEvenement.dart';
import 'package:terangaconnect/presentation/publication_evenement/provider/PublicationEvenementProvider.dart';
import 'package:terangaconnect/presentation/publication_urgence/PublicationUrgence.dart';
import 'package:terangaconnect/presentation/publication_urgence/provider/PublicationUrgenceProvider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => Inscriptionprovider()),
            ChangeNotifierProvider(
                create: (context) => Publicationurgenceprovider()),
            ChangeNotifierProvider(
                create: (context) => Publicationevenementprovider()),
            ChangeNotifierProvider(
                create: (context) => Publicationdemandedonsangprovider()),
            ChangeNotifierProvider(
                create: (context) => ParticipationPretProvider()),
            ChangeNotifierProvider(
                create: (context) => ParticipationMaterielProvider()),
            ChangeNotifierProvider(
                create: (context) => ParticipationDonSangProvider()),
            ChangeNotifierProvider(create: (context) => Connexionprovider()),
          ],
          child: MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigatorService.navigatorKey,
            localizationsDelegates: [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: [Locale('en', '')],
            routes: {
              "/inscription": (context) => Inscription(),
              "/": (context) => Connexion(),
            },
            initialRoute: "/",
            /*  home: AppUrgence(
              utilisateur: Utilisateur(
                  id: 'fd9020d0-f05c-4f37-87db-6dafda5a0795',
                  email: 'senemamadou1999@gmail.com',
                  telephone: '778340335',
                  roles: []),
            ), */
          ),
        );
      },
    );
  }
}
