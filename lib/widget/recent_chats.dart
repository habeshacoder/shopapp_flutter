// import 'dart:html';

// ignore_for_file: prefer_const_constructors

import 'package:expandedflexible/models/message_model.dart';
import 'package:flutter/material.dart';

import '../screens/chat_sreen.dart';

class RecentChats extends StatelessWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final Message chat = chats[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      user: chat.sender,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: chat.unread ? Colors.teal[400] : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(chat.sender.imageUrl),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(chat.sender.name),
                          Container(
                            // color: Colors.red,
                            width: MediaQuery.of(context).size.width - 170,
                            child: Text(
                              chat.text,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Column(
                      children: [
                        Text(
                          chat.time,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chat.unread
                            ? Container(
                                margin: EdgeInsets.only(top: 6),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  'new',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        color: Colors.amber[200],
      ),
    );
  }
}
