import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terangaconnect/models/Message.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/services/DiscussionService.dart';
import 'package:terangaconnect/services/UtilisateurService.dart';

class ChatScreen extends StatefulWidget {
  final String declarationId;
  final String discussionId;
  final Map<String, dynamic>? otherUser;

  const ChatScreen({
    Key? key,
    required this.declarationId,
    required this.discussionId,
    this.otherUser,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DiscussionService _discussionService = DiscussionService();
  final Utilisateurservice _authService = Utilisateurservice();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  List<Message> _messages = [];
  Utilisateur? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _loadMessages();
  }

  Future<void> _getCurrentUser() async {
    final user = await _authService.getutilisateurById(_currentUser!.id!);
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await _discussionService.getMessagesForDiscussion(
          widget.declarationId, widget.discussionId);

      setState(() {
        _messages = messages;
        _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      });

      // Scroll vers le bas après chargement des messages
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentUser == null) {
      return;
    }

    final String recepteurId = widget.otherUser?['_id'] ?? '';

    try {
      final message = await _discussionService.sendMessage(
          contenu: _messageController.text.trim(),
          expediteur: _currentUser!.id!,
          recepteur: recepteurId,
          discussionId: widget.discussionId);

      if (message != null) {
        setState(() {
          _messages.add(message);
          _messageController.clear();
        });

        // Scroll vers le bas après envoi
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur d\'envoi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: Colors.blue.shade100,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.otherUser != null
                    ? widget.otherUser!['nom'] ?? 'Discussion'
                    : 'Discussion',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(child: Text('Aucun message'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isCurrentUser =
                              message.expediteur == _currentUser?.id;

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.contenu,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(message.createdAt),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // Saisie de message
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrivez votre message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
