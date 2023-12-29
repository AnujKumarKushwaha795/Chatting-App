import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/Services/Chat/chat_service.dart';
import 'package:photos_app/consts.dart';

class CompleteProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userUid;

  const CompleteProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userUid
  });
  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController _nameController=TextEditingController();
  final ChatService _chatService=ChatService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Your Profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name:${widget.userName}',style: const TextStyle(fontSize: 20),),
              sizeVer(8),
              Text('Email:${widget.userEmail}',style: const TextStyle(fontSize: 18),),
              sizeVer(8),
              Text('Uid:${widget.userUid}',style: const TextStyle(fontSize: 16),),
              sizeVer(10),

              TextButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text("Edit Name"),
                        content:TextField(
                          controller: _nameController,
                          decoration:const InputDecoration(
                            hintText: "New Name",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        actions: [
                           TextButton(
                               onPressed: (){
                                 Navigator.pop(context);
                                if(_nameController.text.isNotEmpty){
                                 _chatService.editName(widget.userUid, widget.userEmail,_nameController.text);
                                 toast("Name Edited Refresh Page");
                               }
                               else{
                                 Navigator.pop(context);
                               }
                           }, child:const Text('Save'))
                        ],
                      );
                    });
                  },
                  child: const Text("Edit Name",style: TextStyle(fontSize: 20),)
              ),
              sizeVer(10),

              TextButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text("Are you want to delete?"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                _chatService.deleteAccount(widget.userUid);
                                // setState(() {
                                //   if(FirebaseAuth.instance.currentUser!.uid.isEmpty){
                                //     Navigator.pushNamed(context, '/login');
                                //   }
                                // });

                              },
                              child:const Text('Yes'))
                        ],
                      );
                    });
                  },
                  child: const Text("Delete Account",style: TextStyle(fontSize: 20),)
              ),



            ],
          ),
        ),
      ),
    );
  }
}
