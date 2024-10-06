import 'package:terangaconnect/models/Donnateur.dart';

class Pret {
  late String? id;
  late DateTime? datePublication;
  late String type;
  late String declarationId;
  late String donateurId;
  late Donnateur? donnateur;
  late String titre;
  late String description;
  late int duree;
  late List<String>? images = [];
  Pret(
      {this.id,
      this.datePublication,
      required this.type,
      required this.declarationId,
      required this.donateurId,
      required this.titre,
      required this.description,
      required this.duree,
      this.donnateur,
      this.images});

  Pret.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    datePublication = DateTime.parse(jsonData["datePublication"]);
    type = jsonData["type"];
    declarationId = jsonData["declarationId"];
    donateurId = jsonData["donateurId"];
    donnateur = Donnateur.fromJson(jsonData["donnateur"]);
    titre = jsonData["titre"];
    description = jsonData["description"];
    duree = jsonData["duree"];
    images = List.from(jsonData["images"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'declarationId': declarationId,
      'donateurId': donateurId,
      'titre': titre,
      'description': description,
      'duree': duree,
      'type': type,
    };
  }
}
