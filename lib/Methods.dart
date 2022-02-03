
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_demo/DatabaseManager.dart';
Future<User?> createAccount(String name, String email, String password) async{

  FirebaseAuth auth =  FirebaseAuth.instance;
  try{
    User? user = (await auth.createUserWithEmailAndPassword(
        email: email, password: password)).user;

        if(user != null){
          await DatabaseManager().createUserData(name, email, user.uid);
          print('Account Created Successfully');

          user.updateDisplayName(name);

          return user;
        }else{
          print('Failed');
          return user;
        }
  }
  catch(e){
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async{
  FirebaseAuth auth = FirebaseAuth.instance;
  try{
    User? user = (await auth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    if(user != null)
      {
        print("Login Successfull");
        return user;
      }else {
      print("Login Failed");
      return user;
    }
  }catch(e){
    print(e);
    return null;
  }
}

Future logOut() async{
  FirebaseAuth auth = FirebaseAuth.instance;
  try{
    await auth.signOut();
  }
  catch(e){
    print("error");
  }
}

/*Future<List> fetchDetails() async{
  List userlist = [];
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('new users').doc('details').get();
  //userlist = documentSnapshot.data(['details']);
  return userlist;
}*/