import 'dart:ffi';

import 'package:chat_demo/DatabaseManager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserList extends StatefulWidget {
  
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
   
  List userProfileList = [];
  get userMap => null;

  @override
  void initState(){
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async{
    
    dynamic result = await DatabaseManager().getUsersList();

    if(result != null){
      setState(() {
        userProfileList = result;
        
      });
      
    }
    else{
      print('Unable to Retrieve');
      
    }

  }

  String chatRoomId(String user1,String user2){
    if(user1[0].toLowerCase().codeUnits[0] > 
    user2.toLowerCase().codeUnits[0]){
      return '$user1$user2';
    }
    else{
      return "$user2$user1"; 
    }
     
  }  

  Widget build(BuildContext context) {
    FirebaseAuth _auth;
    _auth = FirebaseAuth.instance;
   
    userMap != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("TALKER",style: TextStyle(
          fontSize: 20
        ),),
      ),
      body:  Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: ListView.builder(
          
            itemCount: userProfileList.length,
            itemBuilder: (context,index){
              
              return Stack(
                children: [
                  Card(
                      child:  ListTile(      
                        onTap: (){
                          String roomId = chatRoomId(_auth.currentUser.displayName, userMap['name']);
                        },  
                        title:  Text('${userProfileList[index]['name']}'),
                        subtitle: Text('${userProfileList[index]['email']}'),
                        leading: CircleAvatar(
                          child: Image(image: AssetImage("assets/PicsArt_01-17-09.21.18.jpg"),),
                        ),
                      ), 
                    ),                               
                ],
              );
            }),
      ),
    );
  }
}
