import 'package:chat_demo/DatabaseManager.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class ChatPage extends StatefulWidget {
  final Map<String,dynamic> userMap;
  final String chatRoomId;
  ChatPage({required this.chatRoomId,required this.userMap});
    

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController MsgController = new TextEditingController();
   FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? get chatRoomId => null;

   void onSendMessage() async{

     if(MsgController.text.isNotEmpty){
       Map<String,dynamic> messages = {
       "sendby": _auth.currentUser?.displayName,
       "message": MsgController.text,
     };
     MsgController.clear();
     String? chatRoomId;
     await firestore.collection('chatRoom')
     .doc(chatRoomId).
     collection("chats").
     add(messages);
     }else{
       print("enter text");
     }    
   }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: size.height / 1.25, 
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection("chatRoom").
                  doc(chatRoomId).
                  collection('chat').
                  snapshots(),
      
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.data != null){
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context,index)
                        {
                          Map<String,dynamic> map = 
                          snapshot.data.docs[index].data();
                          return messages(size,map);
                        },
                        );
                    }else{
                      return Container();
                    }
                    
                  },
                ),
      
              ),
            ] 
          ),
          ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: TextField(
              controller: MsgController,
              decoration: InputDecoration(
                labelText: "enter msg",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(onPressed: onSendMessage,icon: Icon(Icons.send),)
        ],
      ),
      
    );
  }
} 

Widget messages(Size size,Map<String, dynamic> map){
  FirebaseAuth _auth = FirebaseAuth.instance;
  return Container(
    width: size.width,
    alignment: map['sendby'] == _auth.currentUser?.displayName ?
    Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 14),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue,
      ),
      child: Text(
        map['message'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
     ),
    );
} 