import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/Authentication/Aut_Page/widgets/form_container_widget.dart';

import '../consts.dart';
import 'ChatPage/chat_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchUserEmailController=TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  bool isMobile=false;
  @override
  Widget build(BuildContext context) {
    isMobile=MediaQuery.of(context).size.width>700?false:true;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: !isMobile?600:MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FormContainerWidget(
                    controller: _searchUserEmailController,
                    hintText: "Email",
                    isPasswordField: false,
                    labelText: "Enter user email",
                  ),
                  sizeVer(30),
                  GestureDetector(
                    onTap: (){
                      // Load state again
                      setState(() {
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child:Text("Search",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore
                          .instance.collection("users")
                          .where('email',
                        isEqualTo: _searchUserEmailController.text.trim(),
                      ).snapshots(),
                     builder: (context,snapshot){
                     if(snapshot.connectionState==ConnectionState.active){
                       if(snapshot.hasData){
                         QuerySnapshot dataSnapshot=snapshot.data as QuerySnapshot;
                         if(dataSnapshot.docs.isNotEmpty){
                           Map<String,dynamic> searchedUser=dataSnapshot.docs[0].data() as Map<String,dynamic>;
                           return ListTile(
                             title: Text(searchedUser['name']),
                             subtitle: Text(searchedUser['email']),
                             leading: CircleAvatar(
                               backgroundColor: Colors.blue,
                               child: Text(searchedUser['name'][0].toString().toUpperCase(),style: const TextStyle(color: Colors.red),),
                             ),
                             onTap: (){
                               // pass the clicked user's UID to chat page
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context)=>ChatPage(receiverUserEmail: searchedUser['email'], receiverUserID: searchedUser['uid'],receiverUserName: searchedUser['name'],)),
                               );
                             },
                             trailing: const Icon(Icons.keyboard_double_arrow_right_outlined),
                           );
                         }
                         else{
                           return const Text("No user found");
                         }
                       }
                       else{
                         return const Text("No user found");
                       }
                     }
                     else{
                       // return const CircularProgressIndicator();
                       return Container();
                     }

                  }
                  ),

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }



}
