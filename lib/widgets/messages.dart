import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.data == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chats')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final chatDocs = chatSnapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    return MessageBubble(
                      key: ValueKey(chatDocs[index].documentID),
                      message: chatDocs[index]['text'],
                      isMe: chatDocs[index]['userId'] == userSnapshot.data.uid,
                      username: chatDocs[index]['username'],
                      userImage: chatDocs[index]['userImage'],
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
