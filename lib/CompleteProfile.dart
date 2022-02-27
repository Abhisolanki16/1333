import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({ Key? key }) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  late File _image;

  @override
  void initState() {
    File _image;
    super.initState();
    
  }


  @override
  Widget build(BuildContext context) {

    Future getImage() async{
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image as File;
        print('Image Path $_image');
      });
    }

    Future uploadImage(BuildContext context) async{
      String fileName =_image.path;
      Reference firebaseStorage = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorage.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;
      setState(() {
        print("Profile Uploaded");

      });
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Profile Picture"),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.blue,
                      child: ClipOval(
                        child: SizedBox(
                          height: 180.0,
                          width: 180.0,
                          child: (_image != null) ? Image.file(_image,fit: BoxFit.fill,)
                          : Image.asset(
                            "assets/PicsArt_01-17-09.21.18.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0,left: 20),
                    child: IconButton(
                      onPressed: (){
                        getImage();
                      },
                      icon:Icon(Icons.person,size: 40,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 100,),

              Container(
                height: 50.0,
                width: 200.0,
                child: ElevatedButton(
                  child: Text("Upload",style: TextStyle(fontSize: 20.0),), 
                  onPressed: (){
                    uploadImage(context);
                  }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  