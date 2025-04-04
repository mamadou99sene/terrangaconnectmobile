import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/Message.dart';

import '../models/Discussion.dart';

class DiscussionService {
  // Récupérer toutes les discussions liées à une déclaration
  Future<List<Discussion>> getDiscussionsByDeclarationId(
      String declarationId) async {
    List<Discussion> discussions = [];
    try {
      http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.communication_Service}discussions/declarations/$declarationId/discussions"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        for (var discussionJson in responseJson) {
          Discussion discussion = Discussion.fromJson(discussionJson);
          discussions.add(discussion);
        }
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération des discussions: $e");
    }

    return discussions;
  }

  // Récupérer les messages d'une discussion
  Future<List<Message>> getMessagesForDiscussion(
      String declarationId, String discussionId) async {
    List<Message> messages = [];
    try {
      http.Response response = await http.get(
        Uri.parse(
            "${API.URL}${API.communication_Service}declarations/$declarationId/discussions/$discussionId/messages"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        for (var messageJson in responseJson) {
          Message message = Message.fromJson(messageJson);
          messages.add(message);
        }
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération des messages: $e");
    }
    return messages;
  }

  // Envoyer un nouveau message
  Future<Message?> sendMessage(
      {required String contenu,
      required String expediteur,
      required String recepteur,
      required String discussionId}) async {
    try {
      final messageData = {
        'contenu': contenu,
        'expediteur': expediteur,
        'recepteur': recepteur,
        'discussion_id': discussionId
      };

      http.Response response = await http
          .post(Uri.parse("${API.URL}${API.communication_Service}messages"),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode(messageData))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return Message.fromJson(responseJson);
      }
    } catch (e) {
      debugPrint("Erreur lors de l'envoi du message: $e");
    }
    return null;
  }

  // Créer une nouvelle discussion
  Future<Discussion?> createDiscussion(
      {required String declarationId, required String utilisateurId}) async {
    try {
      final discussionData = {
        'declaration_id': declarationId,
        'utilisateur_id': utilisateurId
      };

      http.Response response = await http
          .post(Uri.parse("${API.URL}${API.communication_Service}discussions"),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode(discussionData))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return Discussion.fromJson(responseJson);
      }
    } catch (e) {
      debugPrint("Erreur lors de la création de la discussion: $e");
    }
    return null;
  }
}
