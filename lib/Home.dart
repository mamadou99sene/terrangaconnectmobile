import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/App.dart';
import 'package:terangaconnect/presentation/inscription/Inscription.dart';
import 'package:terangaconnect/presentation/inscription/provider/InscriptionProvider.dart';
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
              '/publication': (context) => Publicationurgence(
                    utilisateur: Utilisateur(
                        id: '',
                        email: 'email',
                        telephone: 'telephone',
                        roles: []),
                  ),
              "/event": (context) => Publicationevenement(
                  utilisateur: Utilisateur(
                      id: '',
                      email: 'email',
                      telephone: 'telephone',
                      roles: [])),
              "/don": (context) => Publicationdemandedonsang(
                  utilisateur: Utilisateur(
                      id: '',
                      email: 'email',
                      telephone: 'telephone',
                      roles: []))
            },
            //initialRoute: "/don",
            home: App(),
          ),
        );
      },
    );
  }
}
