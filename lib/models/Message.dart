class Message {
  late String id;
  late String contenu;
  late String expediteur;
  late String recepteur;
  late String discussionId;
  late DateTime createdAt;

  Message(
      {required this.id,
      required this.contenu,
      required this.expediteur,
      required this.recepteur,
      required this.discussionId,
      required this.createdAt});

  Message.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['_id'];
    contenu = jsonData['contenu'];
    expediteur = jsonData['expediteur'];
    recepteur = jsonData['recepteur'];
    discussionId = jsonData['discussion_id'];
    createdAt = jsonData['createdAt'] != null
        ? DateTime.parse(jsonData['createdAt'])
        : DateTime.now();
  }
}
