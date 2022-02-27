
import 'package:chat_demo/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class DatabaseManager{
  final CollectionReference profileList = FirebaseFirestore.instance.collection('profileInfo');
  final CollectionReference messageCollectionRef = FirebaseFirestore.instance.collection('messages');  
  

  Future createUserData(String name, String email, String uid) async{
    return await profileList.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  Future getUsersList() async{
    List itemList = [];
    try{
      await profileList.get().then((QuerySnapshot){
        QuerySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        
    });
    });
      return itemList;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  
  // getConversationMessages(String  chatRoomId, messageMap){
  //   FirebaseFirestore.instance.collection("ChatRoom")
  //       .doc(chatRoomId)
  //       .collection("chat")
  //       .add(messageMap).catchError((e){print(e.toString());});
  // }

  Future createMessage(MessageModel message) async{
    try{
      await messageCollectionRef.doc().set(message.toJson());
    }catch(e){
      if(e is PlatformException){
        return e.message;    
      }
      return e.toString();

    } 
  }
  
  

  
}