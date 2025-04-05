import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/DonEspece.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/participation_materiel/Participation_Materiel.dart';
import 'package:terangaconnect/presentation/participation_pret/Participation_pret.dart';
import 'package:terangaconnect/services/DonEspeceService.dart';
import 'package:terangaconnect/theme/custom_button_style.dart';
import 'package:terangaconnect/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:paydunya/paydunya.dart';

void showUrgenceParticipationDialog(
    BuildContext context, String declarationId, Utilisateur utilisateur) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
              margin: EdgeInsets.only(top: 45),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Comment souhaitez-vous participer ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _buildParticipationButton(
                      context, 'Don en espèces', Icons.monetization_on_outlined,
                      () {
                    Navigator.of(context).pop();
                    _showMontantDialog(context, declarationId, utilisateur);
                  }),
                  SizedBox(height: 10),
                  _buildParticipationButton(
                      context, 'Don de matériel', Icons.inventory_outlined, () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ParticipationMateriel(
                                  declarationId: declarationId,
                                  utilisateur: utilisateur,
                                )));
                  }),
                  SizedBox(height: 10),
                  _buildParticipationButton(
                      context, 'Prêt de bien', Icons.home_outlined, () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ParticipationPret(
                                  declarationId: declarationId,
                                  utilisateur: utilisateur,
                                )));
                  }),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 45,
                child: Icon(
                  Icons.volunteer_activism,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildParticipationButton(BuildContext context, String text,
    IconData iconData, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: CustomElevatedButton(
      height: 44.v,
      text: text.tr,
      buttonStyle: CustomButtonStyles.fillPrimary,
      rightIcon: Icon(
        iconData,
        color: Colors.white,
      ),
      onPressed: onPressed,
    ),
  );
}

// Nouveau dialogue pour saisir le montant
void _showMontantDialog(
    BuildContext context, String declarationId, Utilisateur utilisateur) {
  final TextEditingController montantController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Montant du don"),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: montantController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Montant (FCFA)",
              hintText: "Ex: 5000",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.money),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez saisir un montant";
              }
              final montant = double.tryParse(value);
              if (montant == null || montant <= 0) {
                return "Montant invalide";
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Confirmer"),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Navigator.of(context).pop();
                final montant = double.parse(montantController.text);
                _initierPaiementPaydunya(
                    context, declarationId, utilisateur.id!, montant);
              }
            },
          ),
        ],
      );
    },
  );
}

// Méthode pour initialiser le paiement avec PayDunya et rediriger
Future<void> _initierPaiementPaydunya(BuildContext context,
    String declarationId, String donateurId, double montant) async {
  try {
    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Configuration des clés PayDunya
    final keysApi = KeysApi(
      mode: Environment
          .live, // Changer en Environment.production pour la production
      masterKey: 'd3QGjlE1-SxvE-LFc2-6c5f-32ZBQCextpMi',
      privateKey: 'live_private_MSViseVjCjdaNooSdXS5UXbmXwj',
      token: 'oZ5iRMi5ClRrj9OR4vyD',
    );

    final paydunya = Paydunya(keysApi: keysApi);

    // Configuration de la facture
    final store = Store(
      name: 'terangaconnect',
    );

    final invoice = Invoice(
      totalAmount: montant,
      description: "Don pour une urgence sociale",
      /*  */
    );

    final billing = Billing(
      store: store,
      invoice: invoice,
      /*  customData: {
        'declarationId': declarationId,
        'donateurId': donateurId,
      } */
    );

    // Création du checkout invoice
    final checkoutInvoice =
        await paydunya.createChekoutInvoice(billing: billing);

    // Fermer le dialogue de chargement
    Navigator.of(context).pop();

    // Vérifier si l'URL de redirection est disponible
    if (checkoutInvoice.responseText != null &&
        checkoutInvoice.responseText!.isNotEmpty) {
      // Stocker le token pour la vérification ultérieure
      await _saveTemporaryPaymentInfo(
          declarationId, donateurId, montant, checkoutInvoice.token);

      // Rediriger vers PayDunya
      if (await canLaunch(checkoutInvoice.responseText!)) {
        await launch(checkoutInvoice.responseText!);

        // Afficher une notification pour rappeler à l'utilisateur de revenir à l'app
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Une fois le paiement effectué, revenez à l'application pour confirmer"),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        _showErrorDialog(context, "Impossible d'ouvrir la page de paiement");
      }
    } else {
      _showErrorDialog(context, "URL de paiement PayDunya non disponible");
    }
  } catch (e) {
    print("l'ereeur   ${e}");
    Navigator.of(context).pop();

    // Afficher l'erreur
    _showErrorDialog(context, "Une erreur est survenue: $e");
  }
}

// Méthode pour sauvegarder temporairement les informations de paiement
Future<void> _saveTemporaryPaymentInfo(String declarationId, String donateurId,
    double montant, String token) async {
  // Utiliser SharedPreferences pour stocker les infos temporairement
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pending_payment_token', token);
  await prefs.setString('pending_declaration_id', declarationId);
  await prefs.setString('pending_donateur_id', donateurId);
  await prefs.setDouble('pending_montant', montant);
  await prefs.setString(
      'pending_payment_date', DateTime.now().toIso8601String());
}

// Méthode pour vérifier un paiement en attente (à appeler lors du retour à l'application)
Future<void> verifierPaiementEnAttente(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('pending_payment_token');

  // Si un token existe, vérifier le paiement
  if (token != null && token.isNotEmpty) {
    final declarationId = prefs.getString('pending_declaration_id') ?? '';
    final donateurId = prefs.getString('pending_donateur_id') ?? '';
    final montant = prefs.getDouble('pending_montant') ?? 0.0;

    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Configuration PayDunya
      final keysApi = KeysApi(
        mode: Environment.test,
        masterKey: 'VOTRE_MASTER_KEY',
        privateKey: 'VOTRE_PRIVATE_KEY',
        token: 'VOTRE_TOKEN',
      );

      final paydunya = Paydunya(keysApi: keysApi);

      // Vérifier le statut du paiement
      final statusPaiement = await paydunya.verifyStatePayment(
        invoiceToken: token,
      );

      // Fermer le dialogue de chargement
      Navigator.of(context).pop();

      if (statusPaiement.status == 'completed') {
        // Paiement réussi - Sauvegarder le don dans la base de données
        Donespece don = Donespece(
            type: 'type',
            declarationId: declarationId,
            donateurId: donateurId,
            montant: montant);
        Donespeceservice().saveDonEspece(don);

        // Effacer les données temporaires
        await _clearPendingPaymentInfo();

        // Afficher le message de succès
        _showSuccessDialog(context,
            "Merci pour votre participation! Votre don a été enregistré avec succès.");
      } else if (statusPaiement.status == 'pending') {
        // Paiement toujours en attente
        _showInfoDialog(context,
            "Votre paiement est toujours en cours de traitement. Veuillez vérifier à nouveau plus tard.");
      } else {
        // Paiement échoué ou annulé
        await _clearPendingPaymentInfo();
        _showErrorDialog(context,
            "Le paiement n'a pas été complété. Statut: ${statusPaiement.status}");
      }
    } catch (e) {
      // Fermer le dialogue de chargement en cas d'erreur
      Navigator.of(context).pop();
      _showErrorDialog(context, "Erreur lors de la vérification: $e");
    }
  }
}

Future<void> _clearPendingPaymentInfo() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('pending_payment_token');
  await prefs.remove('pending_declaration_id');
  await prefs.remove('pending_donateur_id');
  await prefs.remove('pending_montant');
  await prefs.remove('pending_payment_date');
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

void _showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Succès"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

void _showInfoDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Information"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
