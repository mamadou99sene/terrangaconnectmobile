class Utilisateur {
  late String? id;
  late String email;
  late String telephone;
  late int? score;
  late List<String> roles = [];
  late String? profile;
  late String? password;

  Utilisateur(
      {this.id,
      required this.email,
      required this.telephone,
      required this.roles,
      this.profile,
      this.score,
      this.password});

  Utilisateur.fromJson(dynamic jsonData) {
    id = jsonData["id"];
    email = jsonData["email"];
    telephone = jsonData["telephone"];
    score = jsonData["score"];
    roles = List<String>.from(jsonData["roles"]);
    profile = (jsonData["profile"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "telephone": telephone,
      "roles": roles,
      "password": password,
    };
  }
}
