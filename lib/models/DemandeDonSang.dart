import 'package:terangaconnect/models/Demandeur.dart';

class Demandedonsang {
  late String? id;
  late String titre;
  late String description;
  late Demandeur? demandeur;
  late String demandeurId;
  late DateTime? datePublication;
  late String? status;
  late String adresse;
  late String classe;
  late String rhesus;
  List<String>? images = [];

  Demandedonsang(
      {this.id,
      required this.titre,
      required this.description,
      this.demandeur,
      this.datePublication,
      required this.demandeurId,
      this.status,
      required this.adresse,
      required this.classe,
      required this.rhesus,
      this.images});

  Demandedonsang.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    titre = jsonData["titre"];
    description = jsonData["description"];
    demandeur = Demandeur.fromJson(jsonData["demandeur"]);
    demandeurId = jsonData["demandeurId"];
    datePublication = DateTime.parse(jsonData["datePublication"].toString());
    status = jsonData["status"];
    adresse = jsonData["adresse"];
    classe = jsonData["classe"];
    rhesus = jsonData["rhesus"];
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'demandeurId': demandeurId,
      'adresse': adresse,
      'classe': classe,
      'rhesus': rhesus,
    };
  }
}
