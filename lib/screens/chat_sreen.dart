// ignore_for_file: prefer_const_constructors

import 'package:expandedflexible/models/message_model.dart';
import 'package:expandedflexible/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  ChatScreen({required this.user});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  messageBuilder(Message message, bool isme) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 5,
        right: 5,
      ),
      margin: isme
          ? EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 80,
            )
          : EdgeInsets.only(
              top: 8,
              bottom: 8,
              right: 80,
            ),
      color: Colors.grey,
      child: Text(message.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.user.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final Message message = messages[index];
                  bool isme = message.sender.id == currentUser.id;
                  return messageBuilder(message, isme);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
