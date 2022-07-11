import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
User? currentUser;
late String currentUserEmail;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String messageText;
  final messageController = TextEditingController();

  getCurrentUser() {
    try {
      currentUser = _auth.currentUser;
      currentUserEmail = currentUser!.email!;
    }
    catch(e) {
      throw 'No user found';
    }

  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageController.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'text':  messageText,
                        'sender': currentUserEmail,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            );
          }

          final messages = snapshot.data?.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for(var message in messages!) {
            final text = message['text'];
            final sender = message['sender'];
            var result = (sender==currentUserEmail);
            final messageBubble = MessageBubble(text, sender, result);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              children: messageBubbles,
            ),
          );
        }
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble(this.text ,this.sender, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            elevation: 5.0,
            borderRadius: isMe ? kSelfBorderRadius : kOthersBorderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

