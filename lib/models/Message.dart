class Message {
  final String id;
  final String contenu;
  final String expediteur;
  final String recepteur;
  final String discussionId;
  final DateTime createdAt;
  
  Message({
    required this.id, 
    required this.contenu, 
    required this.expediteur, 
    required this.recepteur, 
    required this.discussionId,
    required this.createdAt
  });
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'], 
      contenu: json['contenu'], 
      expediteur: json['expediteur'], 
      recepteur: json['recepteur'], 
      discussionId: json['discussion_id'],
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'])
        : DateTime.now()
    );
  }
}
