import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/Services/Chat/chat_service.dart';

import '../consts.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final ChatService _chatService=ChatService();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          // Change color of message
          InkWell(
            onTap: (){
              showDialog(context: context, builder: (context){
               return AlertDialog(
                 title: const Text("Change Color of Chat"),
                 content: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     ListTile(
                       onTap: (){
                         Navigator.pop(context);
                         setState(() {
                            senderColor=Colors.pink;
                            receiverColor=Colors.blue;
                         });
                       },
                       title: const Row(
                         children: [
                           CircleAvatar(backgroundColor: Colors.blue,),
                           CircleAvatar(backgroundColor: Colors.pink,),
                         ],
                       ),
                     ),
                     ListTile(
                       onTap: (){
                         Navigator.pop(context);
                         setState(() {
                           senderColor=Colors.blue;
                           receiverColor=Colors.pink;
                         });
                       },
                       title: const Row(
                         children: [
                           CircleAvatar(backgroundColor: Colors.pink,),
                           CircleAvatar(backgroundColor: Colors.blue,),
                         ],
                       ),
                     ),

                     ListTile(
                       onTap: (){
                         Navigator.pop(context);
                         setState(() {
                           senderColor=Colors.purple;
                           receiverColor=Colors.blue;
                         });
                       },
                       title: const Row(
                         children: [
                           CircleAvatar(backgroundColor: Colors.purple,),
                           CircleAvatar(backgroundColor: Colors.blue,),
                         ],
                       ),
                     ),
                     ListTile(
                       onTap: (){
                         Navigator.pop(context);
                         setState(() {
                           senderColor=Colors.black;
                           receiverColor=Colors.black;
                         });
                       },
                       title: const Row(
                         children: [
                           CircleAvatar(backgroundColor: Colors.black,),
                           CircleAvatar(backgroundColor: Colors.black,),
                         ],
                       ),
                     ),
                   ],
                 ),
               );
             });
            },
            child:  const ListTile(
              leading: Icon(Icons.color_lens,size: 20,),
              title: Text("Color",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
          ),

          // Change font size of message
          InkWell(
            onTap: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Change Font of Chat"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          setState(() {
                            messageFontSize=16.0;
                          });
                        },
                        title: const Row(
                          children: [
                            Text("Low",style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          setState(() {
                            messageFontSize=18.0;
                          });
                        },
                        title: const Row(
                          children: [
                            Text("Medium",style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          setState(() {
                            messageFontSize=20.0;
                          });
                        },
                        title: const Row(
                          children: [
                            Text("High",style: TextStyle(color: Colors.blue),),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
            child:  const ListTile(
              leading: Icon(Icons.font_download,size: 20,),
              title: Text("Font",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
          ),

          // Logout from current account
          InkWell(
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
            child: const ListTile(
              leading: Icon(Icons.logout,size: 20,),
              title: Text("LogOut",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
          ),

          InkWell(
            onTap: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Are you want to delete?"),
                    actions: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            _chatService.deleteAccount(_firebaseAuth.currentUser!.uid);

                          },
                          child:const Text('Yes'))
                    ],
                  );
                });
              },
            child: const ListTile(
              leading: Icon(Icons.delete,size: 20,),
              title: Text("DelAccount",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
          ),

        ],
      ),
    );
  }
}
