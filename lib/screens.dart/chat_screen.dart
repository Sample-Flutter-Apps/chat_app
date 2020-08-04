import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/hB5pZVAZ944sJPrHA9Wv/messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final documents = streamSnapshot.data.documents;
            //print(documents);
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(documents[index]['text']),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('chats/hB5pZVAZ944sJPrHA9Wv/messages').add({
            'text' : 'New text added',
          });
        },
      ),
    );
  }
}
