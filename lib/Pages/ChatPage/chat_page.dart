import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/Model/message.dart';
import 'package:photos_app/Services/Chat/chat_service.dart';
import 'package:photos_app/consts.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUserName;
  const ChatPage({super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiverUserName
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();
  final ChatService _chatService=ChatService();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  bool sender=false;
  bool isMobile=false;
  void sendMessage() async{
    // only send message if there is someone to send
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
    }
    // clear the text controller after sending message
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    isMobile=MediaQuery.of(context).size.width>700?false:true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: ListTile(
          leading: CircleAvatar(child: Text(widget.receiverUserName[0].toUpperCase()),),
          title: Text(widget.receiverUserName),
          subtitle: Text(widget.receiverUserEmail),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: !isMobile?650:MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // message
              Expanded(
                child: _buildMessageList(),
              ),
              // user Input
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }
  // build message list
  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatService.getMessage(
            widget.receiverUserID,
            _firebaseAuth.currentUser!.uid
        ),
        builder: (context,snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Text('Loading...');
        }
        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map((document)=>_buildMessageItem(document)).toList(),
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data=document.data() as Map<String,dynamic>;
    // align message to the right if the sender is the current user , otherwise to the left
    var alignment=(data['senderId']==_firebaseAuth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft);
    data['senderId']==_firebaseAuth.currentUser!.uid?sender=true:sender=false;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment
              . end:CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.7,
              decoration: BoxDecoration(
                color: (sender==true)?Colors.grey.shade400:Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: (sender==true)?CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                  // Text(data['senderEmail'],style: const TextStyle(fontSize: 14,color: Colors.grey),),
                    InkWell(
                         onTap: (){
                           if(data['senderId']==_firebaseAuth.currentUser!.uid){
                              Timestamp currentMessageTimestamp=data['timestamp'];
                              showDialog(
                                context: context, builder: (context){
                                 return AlertDialog(
                                   content:const Text("Delete Message"),
                                   actions:[
                                     TextButton(
                                       onPressed: (){
                                          Navigator.pop(context);
                                         _chatService.deleteMessage(widget.receiverUserID, currentMessageTimestamp);
                                       },
                                     child: const Text("delete"),
                                     )
                                   ],
                                 );
                              });
                           }
                         },
                        child: Text(data['message'],style: TextStyle(fontSize: messageFontSize,color: (sender==true)?senderColor:receiverColor,),)
                    ),

              //       InkWell(
              //       onLongPress: () {
              //       if (data['senderId'] == _firebaseAuth.currentUser!.uid) {
              //       Timestamp currentMessageTimestamp = data['timestamp'];
              //       _chatService.deleteMessage(widget.receiverUserID, currentMessageTimestamp);
              //       }
              //       },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // Display message text
              //       Flexible(
              //         child: Text(
              //           data['message'],
              //           style: TextStyle(
              //             fontSize: messageFontSize,
              //             color: (sender == true) ? senderColor : receiverColor,
              //           ),
              //         ),
              //       ),
              //       // Show delete icon if sender is current user
              //       if (data['senderId'] == _firebaseAuth.currentUser!.uid)
              //         IconButton(
              //           icon: const Icon(Icons.delete),
              //           onPressed: () {
              //             Timestamp currentMessageTimestamp = data['timestamp'];
              //             _chatService.deleteMessage(widget.receiverUserID, currentMessageTimestamp);
              //           },
              //         ),
              //     ],
              //   ),
              // ),

        ],
                ),
              ),
            ),


          ],
        ),

      ),
    );
  }

  // build message input
  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
            child: TextField(
             controller: _messageController,
             obscureText: false,
             decoration: const  InputDecoration(
               hintText: "Enter message",
               border: OutlineInputBorder(
                 borderSide:  BorderSide(width: 0.5),
                 borderRadius: BorderRadius.all(Radius.circular(15)),
               )
             ),
          )
        ),
        IconButton(
            onPressed: (){
              sendMessage();
        },
        icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          )
        )
      ],
    );
  }
}
