import 'package:terangaconnect/models/Demandeur.dart';

class Evenement {
  late String? id;
  late String titre;
  late String description;
  late Demandeur? demandeur;
  late String demandeurId;
  late DateTime? datePublication;
  late String? status;
  late String lieu;
  late String type;
  late DateTime dateDebut;
  late DateTime dateFin;
  List<String>? images = [];

  Evenement(
      {this.id,
      required this.titre,
      required this.description,
      this.demandeur,
      this.datePublication,
      required this.demandeurId,
      this.status,
      required this.lieu,
      required this.type,
      required this.dateDebut,
      required this.dateFin,
      this.images});

  Evenement.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    titre = jsonData["titre"];
    description = jsonData["description"];
    demandeur = Demandeur.fromJson(jsonData["demandeur"]);
    demandeurId = jsonData["demandeurId"];
    datePublication = DateTime.parse(jsonData["datePublication"].toString());
    status = jsonData["status"];
    lieu = jsonData["lieu"];
    type = jsonData["type"];
    dateDebut = DateTime.parse(jsonData["dateDebut"].toString());
    dateFin = DateTime.parse(jsonData["dateFin"].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'demandeurId': demandeurId,
      'lieu': lieu,
      'type': type,
      'dateDebut': dateDebut,
      'dateFin': dateFin
    };
  }
}
