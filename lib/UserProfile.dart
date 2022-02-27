

// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:chat_demo/New/New.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'UserModel.dart';

//import 'package:talkr_demo/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection("create").snapshots();
  late String myEmail;
  late String name;
  bool _isSigningOut = false;
  bool posts = true;
  ImagePicker image = ImagePicker();
  File? file;
  String url = "";
  

  @override
  void initState() {
    super.initState();
  }

  getImage() async{
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async{
    var imageFile = FirebaseStorage.instance.ref().child("path").child("/.jpg");
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;

    //for downloading
    url = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('images').doc().set({
      "imageUrl":url
    });
    print(url);

  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final firebase = FirebaseFirestore.instance;
    Size size = MediaQuery.of(context).size;
    File? file;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text('Profile'),
        actions: [
          _isSigningOut
              ? const CircularProgressIndicator()
              : FlatButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isSigningOut = true;
                    });

                    await FirebaseAuth.instance.signOut();
                    setState(() {
                      _isSigningOut = false;
                    });
                    
                    
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.deepPurpleAccent,
                  ),
                  label: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                ),
                
        ],
      ),
      floatingActionButton: FloatingActionButton(
                  onPressed: (){getImage();},
                  child: CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.add),
                  ),),
      body: SingleChildScrollView(
        child: Stack(
          
          children: [

            FutureBuilder(
              builder: (context, snapshot) {        
              return Container(
                margin: EdgeInsets.only(top: 10,left: 20),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: file == null 
                  ? const AssetImage("assets/PicsArt_01-17-09.21.18.jpg")
                  
                  : FileImage(File(file.path)) as ImageProvider,
                  ),
              );
              }   
            ),

          

             Container(
                          margin: EdgeInsets.only(top: 100,left: 220),
                          child: MaterialButton(
                          color: Colors.white12,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Edit()));
                          },
                          child: Text("Edit Profile",style: TextStyle(fontSize: 14,color: Colors.white),
                          ),
                        ),
                      ),
            


                Container(
                
                margin:  EdgeInsets.only(top: 50,left: 200),
                
                child: Row(
                  children:  [
                    Text("Post",style: TextStyle(fontSize: 20,color: Colors.white),),
                    SizedBox(width: 10,),
                    Text("Friends",style: TextStyle(fontSize: 20,color: Colors.white),)
                        
                    ],
                  ),                 
                ),


                Container(
                  margin: EdgeInsets.only(top: 150,left: 20),
                  child: StreamBuilder(
                    
                    stream: FirebaseFirestore.instance.collection("data").snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if(!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      return Column(
                        children: [
                          
                          Text(snapshot.data.docs[0]["username"],style: TextStyle(color: Colors.white),),
                          Text(snapshot.data.docs[0]['email'],style: TextStyle(color: Colors.white),),
                          Text(snapshot.data.docs[0]['bio'],style: TextStyle(color: Colors.white),),
                        
                        ]);
                    },

                  ),
                ),

                Container(alignment: Alignment.center,
                height: 50,
                color: Colors.grey.shade800,
                width: double.infinity,
                  margin: EdgeInsets.only(top:220),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[ 
                    Icon(Icons.photo_library,color: Colors.white,size: 30,),
                    SizedBox(width: 10,),
                    Text("Posts",style: TextStyle(fontSize: 20,color: Colors.white),)
                  ])
                  ),

                 

            Container( 
              margin: const EdgeInsets.only(top: 280),
              child: StreamBuilder(
                stream: firebase.collection("images").snapshots(),
                builder: ( context, AsyncSnapshot<QuerySnapshot> snapshot)
                {
                  if(snapshot.connectionState == ConnectionState.done){
                    return const Text("Connection Done");
                  }else if(snapshot.connectionState== ConnectionState.waiting){
                    return const Text("Connection Waiting");
                  }else{
                    return GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 2), 
                      itemCount: snapshot.data!.docs.length,
                      
                      itemBuilder: (context,index){
                        QueryDocumentSnapshot x = snapshot.data!.docs[index];
                        return Card(
                            //child : Image.asset("assets/PicsArt_01-17-09.21.18.jpg",fit: BoxFit.fill)
                            child : Image.network(x['imageUrl'],fit: BoxFit.fill)
                            );

                      });
                  }
                  
                }
               ),
            ),               
          ]
        ),
      )
    );
  }
}
