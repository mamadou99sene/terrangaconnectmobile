import 'package:terangaconnect/models/Donnateur.dart';

class Donmateriel {
  late String? id;
  late DateTime? datePublication;
  late String type;
  late String declarationId;
  late String donateurId;
  late Donnateur? donnateur;
  late String titre;
  late String description;
  late List<String>? imagesDon = [];
  Donmateriel(
      {this.id,
      this.datePublication,
      required this.type,
      required this.declarationId,
      required this.donateurId,
      required this.titre,
      required this.description,
      this.donnateur,
      this.imagesDon});

  Donmateriel.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    datePublication = DateTime.parse(jsonData["datePublication"]);
    type = jsonData["type"];
    declarationId = jsonData["declarationId"];
    donateurId = jsonData["donateurId"];
    donnateur = Donnateur.fromJson(jsonData["donnateur"]);
    titre = jsonData["titre"];
    description = jsonData["description"];
    imagesDon = List.from(jsonData["imagesDon"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'declarationId': declarationId,
      'donateurId': donateurId,
      'titre': titre,
      'description': description,
      'type': type,
    };
  }
}
