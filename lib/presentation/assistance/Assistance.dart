import 'package:flutter/material.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';
import 'package:terangaconnect/presentation/AppDemandeDon.dart';
import 'package:terangaconnect/presentation/AppEvent.dart';
import 'package:terangaconnect/presentation/AppUrgence.dart';
import 'package:terangaconnect/services/AssistanceService.dart';
import 'package:terangaconnect/widgets/app_bar/appbar_leading_image.dart';
import 'package:terangaconnect/widgets/app_bar/appbar_title.dart';
import 'package:terangaconnect/widgets/app_bar/custom_app_bar.dart';
import 'dart:async';

class Assistance extends StatefulWidget {
  final Utilisateur utilisateur;

  Assistance({required this.utilisateur});

  @override
  _AssistanceState createState() => _AssistanceState();
}

class _AssistanceState extends State<Assistance> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'Assistance';
  bool _isLoading = false;
  StreamSubscription? _streamSubscription;
  String _currentResponse = '';

  @override
  void initState() {
    super.initState();
    // Initialiser la conversation avec le message de bienvenue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AssistanceService.initializeConversation().then((_) {
        setState(() {});
        _scrollToBottom();
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    setState(() {
      AssistanceService.addUserMessage(message);
      _messageController.clear();
      _isLoading = true;
      _currentResponse = '';
    });

    _scrollToBottom();

    // Annuler toute souscription de stream précédente
    _streamSubscription?.cancel();

    // Démarrer la nouvelle requête
    _streamSubscription =
        AssistanceService.getAssistance(message).listen((response) {
      setState(() {
        _currentResponse += response;
      });
      _scrollToBottom();
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $error')),
      );
    }, onDone: () {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          _buildMessages(),
                          if (_isLoading) _buildTypingIndicator(),
                        ],
                      ),
                    ),
                  ),
                  _buildMessageInput(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return Column(
      children: [
        ...AssistanceService.messageHistory
            .map((message) => _buildMessageItem(
                message.text, message.formattedTime,
                isUserMessage: message.isUserMessage))
            .toList(),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Teranga est en train d'écrire "),
            SizedBox(width: 10),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(String text, String time,
      {required bool isUserMessage}) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text, style: theme.textTheme.headlineLarge),
            SizedBox(height: 5),
            Text(
              time, // Maintenant time est formaté
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Rédiger votre message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isLoading ? Colors.grey : Colors.black54,
            ),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(150.0),
      child: Column(
        children: [
          CustomAppBar(
            leadingWidth: 78.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imageTeranga,
              margin: EdgeInsets.only(
                left: 30.h,
                top: 9.v,
                bottom: 4.v,
              ),
            ),
            title: AppbarTitle(
              text: "Teranga Connect",
              margin: EdgeInsets.only(left: 10.h),
            ),
            actions: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.1,
                margin: EdgeInsets.symmetric(vertical: 5.v),
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.h),
                  border: Border.all(color: Color(0xFFE0B589)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      color: Color(0xFFB85C38),
                      size: 24.h,
                    ),
                    SizedBox(width: 5.h),
                    Text(
                      "Impact",
                      style: TextStyle(
                        color: Color(0xFF5C3D2E),
                        fontSize: 16.v,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.v),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomButtonIcon("Urgences", Icons.warning, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppUrgence(
                                utilisateur: widget.utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Événements", Icons.event, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppEvent(
                                utilisateur: widget.utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Demande sang", Icons.favorite, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppDemandeDonSang(
                                utilisateur: widget.utilisateur,
                              )));
                }),
                _buildBottomButtonIcon("Assistance", Icons.assistant, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtonIcon(
      String label, IconData icon, VoidCallback onPressed) {
    final isSelected = selectedCategory == label;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color:
                isSelected ? Color.fromARGB(255, 1, 250, 26) : Colors.grey[500],
            size: 24.h,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            color:
                isSelected ? Color.fromARGB(255, 1, 250, 26) : Colors.grey[500],
            fontSize: 12.v,
          ),
        ),
      ],
    );
  }
}
