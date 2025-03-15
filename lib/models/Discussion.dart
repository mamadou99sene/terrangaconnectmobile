import 'package:terangaconnect/models/Message.dart';

class Discussion {
  final String id;
  final String declarationId;
  final String utilisateurId;
  List<Message> messages;
  
  Discussion({
    required this.id, 
    required this.declarationId, 
    required this.utilisateurId,
    this.messages = const []
  });
  
  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['_id'], 
      declarationId: json['declaration_id'], 
      utilisateurId: json['utilisateur_id'],
      messages: json['messages'] != null 
        ? List<Message>.from(json['messages'].map((m) => Message.fromJson(m)))
        : []
    );
  }
}
