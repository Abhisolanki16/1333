
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_demo/Abhi/ProfileScreen.dart';
import 'package:chat_demo/UserProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_methods.dart';


class FinalEdit extends StatefulWidget {
  const FinalEdit({ Key? key }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _FinalEditState createState() => _FinalEditState();
}

class _FinalEditState extends State<FinalEdit> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
} 
  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        username: _nameController.text,
        bio: _bioController.text,
        file: _image!);

        if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const ResponsiveLayout(
      //       mobileScreenLayout: MobileScreenLayout(),
      //       webScreenLayout: WebScreenLayout(),
      //    ),
      //  ),
      //);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      //showSnackBar(context, res);
    }
  }

 

  

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
                
              },
              
              child: _image != null ? CircleAvatar(
              radius: 80,
              backgroundColor: Colors.red,
              backgroundImage: MemoryImage(_image!),
                
              )
              : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                        
            ),

            Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo,color: Colors.white,),
                    ),
                  ),

            SizedBox(height: 30,),

            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                  labelText: "username",
                  prefixIcon: Icon(Icons.person,color: Colors.white,),
                  labelStyle: TextStyle(fontSize: 18,color: Colors.white)
                ),
                ),


                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                  labelText: "email",
                  prefixIcon: Icon(Icons.email,color: Colors.white,),
                  labelStyle: TextStyle(fontSize: 18,color: Colors.white)
                ),
                ),

                TextFormField(
                  controller: _bioController,
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
                    signUpUser();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile(uid: FirebaseAuth.instance.currentUser!.uid,))); 
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

