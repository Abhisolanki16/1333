import 'package:chat_demo/Abhi/EditProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import 'firestore_methods.dart';
import 'follow_button.dart';

class MyProfile extends StatefulWidget {
  final String uid;
  const MyProfile({ Key? key, required this.uid }) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

Function()? function;

class _MyProfileState extends State<MyProfile> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
   }

   getData() async{
     try{
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

          var postSnap = await FirebaseFirestore.instance
          .collection('images')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
          postLen = postSnap.docs.length;
          userData = userSnap.data()!;
          followers = userSnap.data()!['followers'].length;
          following = userSnap.data()!['following'].length;
          isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
          setState(() {});

     }catch(e){
       print(e.toString());
     }
     setState(() {
      isLoading = false;
    });

   }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
    :Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.grey.shade900,
        title: userData['username'] != null ? Text(userData['username']) : Text("Hello"),
      ),  
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: userData["photoUrl"] != null ? NetworkImage(userData['photoUrl']) : NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png"),
                      radius: 50,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStateColunn(20, "posts"),
                          buildStateColunn(100, "followers"),
                          buildStateColunn(10, "following"),
                        ],
                      ), 
                    ), 
                  ]
                ),
                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Edit Profile',
                                            backgroundColor:
                                                Colors.black,
                                            textColor: Colors.white,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FinalEdit(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                        Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15
                        ),
                        child: userData['username'] != null ? Text(
                          userData['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        )
                        : Text("Username") 
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: userData['username'] != null
                        ? Text(
                          userData['bio'],
                        )
                        : Text("Bio")
                      ), 
              ],
            ),
          ),
          const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('images')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: snap['postUrl'] != null ? NetworkImage(snap['postUrl']) : NetworkImage("https://images.ctfassets.net/hrltx12pl8hq/7yQR5uJhwEkRfjwMFJ7bUK/dc52a0913e8ff8b5c276177890eb0129/offset_comp_772626-opt.jpg?fit=fill&w=800&h=300"),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }),

        ],
      ), 
      floatingActionButton: CircleAvatar(
        radius: 30,
        child: IconButton(
          color: Colors.white,
          onPressed: () {},
          icon: Icon(Icons.add_a_photo),)),   
    );
  }

  Column buildStateColunn(int num,String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        ),

        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white
          ),
          ),
        ),
      ],
    );
  }
}