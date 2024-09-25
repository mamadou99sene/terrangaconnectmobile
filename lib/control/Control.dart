import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:terangaconnect/models/DemandeDonSang.dart';
import 'package:terangaconnect/models/Evenement.dart';
import 'package:terangaconnect/models/UrgenceSociale.dart';
import 'package:url_launcher/url_launcher.dart';

class Control {
  String getDurationString(Duration duration) {
    if (duration.inSeconds <= 0) return 'Passé';
    if (duration.inDays > 0) return '${duration.inDays} jours';
    if (duration.inHours > 0) return '${duration.inHours} heures';
    if (duration.inMinutes > 0) return '${duration.inMinutes} min';
    return '${duration.inSeconds} sec';
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Date non spécifiée';
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}';
  }

  void shareUrgence(Urgencesociale urgence) {
    Share.share('Découvrez cette urgence sociale : ${urgence.titre}');
  }

  void shareEvent(Evenement evenement) {
    Share.share('Découvrez cet evenement : ${evenement.titre}');
  }

  void shareDemandedonsang(Demandedonsang demande) {
    Share.share('Découvrez cette demande de sang : ${demande.titre}');
  }

  void launchWhatsApp(BuildContext context, String phone) async {
    String url = "https://wa.me/$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d'ouvrir WhatsApp")),
      );
    }
  }
}
