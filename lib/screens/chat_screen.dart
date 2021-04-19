import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore=Firestore.instance;
FirebaseUser loginUser;
class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth=FirebaseAuth.instance;

    String message;


      @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }
    void getCurrentUser() async {
      try{
      final user =  await _auth.currentUser();
      if(user != null) {
        loginUser = user;
        print(loginUser);
                }
      }
      catch(e){
        print(e);
      }
    }

    void messagesStream() async{
        await for( var snapshot in  _firestore.collection('messages').snapshots())
          {
            for( var message  in snapshot.documents){
              print (message.data);
            }
          }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
              _auth.signOut();
               Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text' : message,
                        'sender': loginUser.email,
                      });
                    },
                    child: Text(
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context , snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages=snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles=[];
        for(var message in messages){
          final messageText=message.data['text'];
          final messageSender=message.data['sender'];

          final currentuser = loginUser.email;

          if(currentuser == messageSender){

          }

          final messageBubble=MessageBubble(sender: messageSender ,
            text: messageText,
            Isme: currentuser ==messageSender,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:20.0 ),
            children: messageBubbles,
          ),
        );

      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender ,this.text ,this.Isme})
;
  final String sender;
  final String text;
  final bool Isme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: Isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender ,
          style: TextStyle( fontSize: 12.0),),
          Material(
            borderRadius: Isme? BorderRadius.only(topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0))
                :BorderRadius.only(bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0), topRight: Radius.circular(30.0))
            ,
            elevation: 5.0,
            color: Isme ? Colors.lightBlueAccent : Colors.blue,

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
              child: Text(text,
                style: TextStyle(fontSize:15.0,
                      color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
