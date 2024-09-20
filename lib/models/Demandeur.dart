class Demandeur {
  late String id;
  late String email;
  late String telephone;
  late double score;

  Demandeur(
      {required this.id,
      required this.email,
      required this.telephone,
      required this.score});
  Demandeur.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    email = jsonData["email"];
    telephone = jsonData["telephone"];
    score = jsonData["score"];
  }
}
