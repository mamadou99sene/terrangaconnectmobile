class Donnateur {
  late String id;
  late String email;
  late String telephone;
  late double score;
  late String? profile;
  Donnateur(
      {required this.id,
      required this.email,
      required this.telephone,
      required this.score,
      this.profile});
  Donnateur.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    email = jsonData["email"];
    telephone = jsonData["telephone"];
    score = jsonData["score"];
    profile = (jsonData["profile"] ?? '');
  }
}
