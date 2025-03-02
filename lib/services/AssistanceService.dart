import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:terangaconnect/config/API.dart';
import 'package:terangaconnect/models/MessageChat.dart';

class AssistanceService {
  static List<MessageChat> messageHistory = [];

  // Méthode pour ajouter un message utilisateur
  static void addUserMessage(String text) {
    final now = DateTime.now();
    final timeString = "il y a quelques secondes";
    messageHistory
        .add(MessageChat(text: text, timestamp: now, isUserMessage: true));
  }

  // Méthode pour ajouter un message de réponse
  static void addResponseMessage(String text) {
    final now = DateTime.now();
    final timeString = "il y a quelques secondes";
    messageHistory
        .add(MessageChat(text: text, timestamp: now, isUserMessage: false));
  }

  static Stream<String> getAssistance(String query) async* {
    try {
      // Requête standard avec http.get
      final request = http.Request(
          'GET',
          Uri.parse(
              "${API.URL}${API.assistance_Service}/assistance?query=$query"));

      request.headers.addAll({
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'text/plain;charset=UTF-8'
      });

      final streamedResponse =
          await http.Client().send(request).timeout(Duration(seconds: 15));

      String completeResponse = '';

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        await for (final chunk
            in streamedResponse.stream.transform(utf8.decoder)) {
          completeResponse += chunk;
          yield chunk;
        }

        // Ajouter la réponse complète à l'historique des messages
        addResponseMessage(completeResponse);
      } else {
        final errorMessage = 'Erreur: ${streamedResponse.statusCode}';
        addResponseMessage(errorMessage);
        yield errorMessage;
        throw Exception('Erreur de requête: ${streamedResponse.statusCode}');
      }
    } on TimeoutException {
      final errorMessage = 'Erreur: Délai d\'attente dépassé.';
      addResponseMessage(errorMessage);
      yield errorMessage;
      throw TimeoutException('La requête a dépassé le délai d\'attente.');
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'appel de l\'API d\'assistance: $e');
      }
      final errorMessage = 'Erreur: Impossible de récupérer la réponse. $e';
      addResponseMessage(errorMessage);
      yield errorMessage;
      rethrow;
    }
  }

  // Méthode pour initialiser la conversation avec un message de bienvenue
  static Future<void> initializeConversation() async {
    if (messageHistory.isEmpty) {
      addResponseMessage("Bonjour, comment puis-je vous aider aujourd'hui ?");
    }
  }
}
