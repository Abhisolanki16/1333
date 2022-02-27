
import 'package:chat_demo/Abhi/EditProfile.dart';
import 'package:chat_demo/Abhi/ProfileScreen.dart';
import 'package:chat_demo/ChatPage.dart';
import 'package:chat_demo/New/New.dart';
import 'package:chat_demo/UserList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'UserProfile.dart';


Future main() async {
  
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: ChatPage( chatRoomId: FirebaseAuth.instance.currentUser!.uid, userMap: {},),
    );
  }
}