import 'package:terangaconnect/models/Donnateur.dart';

class Donespece {
  late String? id;
  late DateTime? datePublication;
  late String type;
  late String declarationId;
  late String donateurId;
  late Donnateur? donnateur;
  late double montant;
  Donespece({
    this.id,
    this.datePublication,
    required this.type,
    required this.declarationId,
    required this.donateurId,
    required this.montant,
    this.donnateur,
  });

  Donespece.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    datePublication = DateTime.parse(jsonData["datePublication"]);
    type = jsonData["type"];
    declarationId = jsonData["declarationId"];
    donateurId = jsonData["donateurId"];
    donnateur = Donnateur.fromJson(jsonData["donnateur"]);
    montant = jsonData["montant"];
  }

  Map<String, dynamic> toJson() {
    return {
      'declarationId': declarationId,
      'donateurId': donateurId,
      'montant': montant,
      'type': type,
    };
  }
}
