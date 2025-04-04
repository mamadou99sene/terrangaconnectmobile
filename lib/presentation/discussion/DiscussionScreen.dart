import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terangaconnect/models/Discussion.dart';
import 'package:terangaconnect/models/Message.dart';
import 'package:terangaconnect/presentation/discussion/ChatScreen.dart';
import 'package:terangaconnect/services/DiscussionService.dart';
import 'package:terangaconnect/services/UtilisateurService.dart';

class DiscussionsScreen extends StatefulWidget {
  final String declarationId;

  const DiscussionsScreen({Key? key, required this.declarationId})
      : super(key: key);

  @override
  _DiscussionsScreenState createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  final DiscussionService _discussionService = DiscussionService();
  late Utilisateurservice utilisateurservice;
  bool _isLoading = true;
  List<Discussion> _discussions = [];
  Map<String, dynamic> _users = {};
  Map<String, Message> _lastMessages = {};

  @override
  void initState() {
    super.initState();
    _loadDiscussions();
  }

  Future<void> _loadDiscussions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _discussions = await _discussionService
          .getDiscussionsByDeclarationId(widget.declarationId);

      // Charger les informations des utilisateurs et les derniers messages
      for (var discussion in _discussions) {
        // Récupérer l'information de l'utilisateur
        if (!_users.containsKey(discussion.utilisateurId)) {
          final user = await utilisateurservice
              .getutilisateurById(discussion.utilisateurId);
          setState(() {
            _users[discussion.utilisateurId] = user;
          });
                }

        // Récupérer le dernier message
        final messages = await _discussionService.getMessagesForDiscussion(
            widget.declarationId, discussion.id);

        if (messages.isNotEmpty) {
          setState(() {
            messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            _lastMessages[discussion.id] = messages.first;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.declarationId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussions'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _discussions.isEmpty
              ? Center(child: Text('Aucune discussion pour le moment'))
              : ListView.builder(
                  itemCount: _discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = _discussions[index];
                    final user = _users[discussion.utilisateurId];
                    final lastMessage = _lastMessages[discussion.id];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      title: Text(user != null
                          ? user['nom'] ?? 'Utilisateur'
                          : 'Utilisateur inconnu'),
                      subtitle: lastMessage != null
                          ? Text(
                              lastMessage.contenu,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text('Aucun message'),
                      trailing: lastMessage != null
                          ? Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(lastMessage.createdAt),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              declarationId: widget.declarationId,
                              discussionId: discussion.id,
                              otherUser: user,
                            ),
                          ),
                        ).then((_) =>
                            _loadDiscussions()); // Recharger après retour
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _loadDiscussions,
      ),
    );
  }
}
