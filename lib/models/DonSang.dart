import 'package:terangaconnect/models/Donnateur.dart';

class Donsang {
  late String? id;
  late DateTime? datePublication;
  late String type;
  late String declarationId;
  late String donateurId;
  late Donnateur? donnateur;
  late String adresseDonnateur;
  Donsang({
    this.id,
    this.datePublication,
    required this.type,
    required this.declarationId,
    required this.donateurId,
    required this.adresseDonnateur,
    this.donnateur,
  });

  Donsang.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    datePublication = DateTime.parse(jsonData["datePublication"]);
    type = jsonData["type"];
    declarationId = jsonData["declarationId"];
    donateurId = jsonData["donateurId"];
    donnateur = jsonData["donnateur"];
    adresseDonnateur = jsonData["adresseDonnateur"];
  }

  Map<String, dynamic> toJson() {
    return {
      'declarationId': declarationId,
      'donateurId': donateurId,
      'adresseDonnateur': adresseDonnateur,
      'type': type,
    };
  }
}
