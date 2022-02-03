
import 'package:chat_demo/ChatPage.dart';
import 'package:chat_demo/CreateAccount.dart';
import 'package:chat_demo/LoginScreen.dart';
import 'package:chat_demo/UserList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


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
      home: LoginScreen(),
    );
  }
}