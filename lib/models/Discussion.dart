import 'package:terangaconnect/models/Message.dart';

class Discussion {
  late String id;
  late String declarationId;
  late String utilisateurId;
  late List<String> messages;

  Discussion(
      {required this.id,
      required this.declarationId,
      required this.utilisateurId,
      this.messages = const []});

  Discussion.fromJson(Map<String, dynamic> data) {
    id = data['_id'];
    declarationId = data['declaration_id'];
    utilisateurId = data['utilisateur_id'];
    messages = data['messages'] != null ? List.from(data['messages']) : [];
  }
}
