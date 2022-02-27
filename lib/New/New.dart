
import 'dart:io';
import 'package:chat_demo/UserProfile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


class Edit extends StatefulWidget {
  const Edit({ Key? key }) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  var username , email , bio;
  ImagePicker image = ImagePicker();
  File? file;
  String url = "";

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


  getUsername(name){
    this.username = name;
  }

  create(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("data").doc(username);

    Map<String,dynamic> Details = {
      "username": _nameController.text,
      "email": _emailController.text,
      "bio": _bioController.text
    };
    documentReference.set(Details);
  }


   TextEditingController _nameController = TextEditingController();
   TextEditingController _emailController = TextEditingController();
   TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text("Edit profile"),
        actions: [
          IconButton(onPressed: (){ 
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));     
          }, icon: Icon(Icons.done,)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),   
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: CircleAvatar(
              radius: 80,
              backgroundImage: file == null 
              ? const AssetImage("assets/PicsArt_01-17-09.21.18.jpg")
              
              : FileImage(File(file!.path)) as ImageProvider,
                
              ),
            ),

            SizedBox(height: 30,),

            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                TextFormField(
                  decoration: InputDecoration(
                  labelText: "username",
                  prefixIcon: Icon(Icons.person,color: Colors.white,),
                  labelStyle: TextStyle(fontSize: 18,color: Colors.white)
                ),
                ),


                TextFormField(
                  decoration: InputDecoration(
                  labelText: "email",
                  prefixIcon: Icon(Icons.email,color: Colors.white,),
                  labelStyle: TextStyle(fontSize: 18,color: Colors.white)
                ),
                ),

                TextFormField(
                  decoration: InputDecoration(
                  labelText: "bio",
                  prefixIcon: Icon(Icons.text_fields,color: Colors.white,),
                  labelStyle: TextStyle(fontSize: 18,color: Colors.white)
                ),
                ),
              ],),
            ),

            Container(
              height: 40,
              margin: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  MaterialButton(
                  color: Colors.grey.shade700,
                  onPressed: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                   child: Text("Cancle",style: TextStyle(color: Colors.white))),

                  MaterialButton(
                    color: Colors.grey.shade700,
                    
                  onPressed: (){
                    uploadFile();
                    create();
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen())); 
                  },
                   child: Text("Save",style: TextStyle(color: Colors.white),))

                   ]
                  ),
            ),

          ],
        ),
      ),
      
    );
  }
}

