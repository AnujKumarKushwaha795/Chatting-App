
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/Pages/ChatPage/chat_page.dart';
import 'package:photos_app/Pages/complete_profile_page.dart';
import 'package:photos_app/Pages/drawer_page.dart';
import 'package:photos_app/Pages/search_page.dart';
import 'package:photos_app/consts.dart';
class HomePage extends StatefulWidget {
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  bool isMobile=false;
   final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
   String currentUserName='';
   String currentUserEmail='';

  // void fetchUserData() async {
  //   try {
  //     var documentSnapshot = await _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).get();
  //     if (documentSnapshot.exists) {
  //        var userData = documentSnapshot.data();
  //        // currentUserUid = userData['uid'];
  //        currentUserEmail = userData?['email'];
  //        currentUserName = userData?['name'];
  //     } else {
  //       // Document with the given UID does not exist
  //     }
  //   } catch (e) {
  //     // Handle exceptions or errors here
  //     toast(e.toString());
  //     log('Error fetching user data: $e');
  //   }
  // }
  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      var documentSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).get();
      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data();
        return userData as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if document doesn't exist
      }
    } catch (e) {
      log('Error fetching user data: $e');
      return {}; // Return an empty map in case of an error
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // fetchUserData();
  //   // listOfUsers();
  //   setState(() {
  //     fetchUserData();
  //     listOfUsers();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
  isMobile=(MediaQuery.of(context).size.width>700)?false:true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
          // automaticallyImplyLeading: false,
          title:  FutureBuilder<Map<String, dynamic>>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...'); // Display 'Loading...' while fetching data
            } else {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                // Use the retrieved data in the app bar title
                return ListTile(
                  title: Text(snapshot.data!['name'].toString().split(' ')[0]),
                  subtitle: Text(snapshot.data!['email']),
                  leading: InkWell(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context){
                         return CompleteProfilePage(
                             userName: snapshot.data!['name'],
                             userEmail: snapshot.data!['email'],
                             userUid: snapshot.data!['uid']
                         );
                       })
                       );
                      },
                      child: CircleAvatar(child: Text(snapshot.data!['name'][0].toString().toUpperCase()),)),
                );
                  // Text(snapshot.data!['name']); // Show the user's name
                // return Text(snapshot.data!['email']); // Show the user's email
              } else {
                return const Text('No user'); // Show 'No Data' if no user data available
              }
            }
          },
        ),
        actions: [
           // sizeHor(30),
          InkWell(
            child: const Icon(Icons.search),
            onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                 builder: (context){
                 return  SearchPage();
                }
              )
            );
          },
          ),
          sizeHor(10),
        ],
      ),
      // Drawer of list of settings
      drawer: Drawer(
        child:DrawerPage(),
      ),

      body: Center(
          child: SizedBox(
              width: !isMobile?700:MediaQuery.of(context).size.width,
              child: listOfUsers()
          ),
      ),


      // body: Container(),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //    const Center(child: Text("Welcome Home buddy!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)),
      //    const  SizedBox(height: 30,),
      //     GestureDetector(
      //       onTap: (){
      //         FirebaseAuth.instance.signOut();
      //         Navigator.pushNamed(context, "/login");
      //       },
      //     child: Container(
      //       height: 45,
      //       width: 100,
      //       decoration: BoxDecoration(
      //         color: Colors.blue,
      //         borderRadius: BorderRadius.circular(10)
      //       ),
      //       child: const Center(child: Text("Sign out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
      //     ),
      //     ),
      //
      //     // Show list of all user except current user
      //
      //     listOfUsers(),
      //
      //
      //   ],
      // )
    );
  }

  Widget listOfUsers(){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder:(context,snapshot){
          if(snapshot.hasError){
            return const Text("Error in fetching users");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text("Waiting for connection");
          }
          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc)=>_buildUserListItem(doc)).toList(),
          );
         }
        );
  }

  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String,dynamic> data=document.data()!as Map<String,dynamic>;
    if(_auth.currentUser!.email!=data['email']){
      return ListTile(
        title: Text(data['name']),
        subtitle: Text(data['email']),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(data['name'][0].toString().toUpperCase(),style: const TextStyle(color: Colors.red),),
        ),

        onTap: (){
          // pass the clicked user's UID to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)=>ChatPage(receiverUserEmail: data['email'], receiverUserID: data['uid'],receiverUserName: data['name'],)),
          );
        },
      );
    }
    else{
        return Container();
      }
  }

}
