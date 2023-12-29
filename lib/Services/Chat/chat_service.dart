import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/Model/message.dart';

class ChatService extends ChangeNotifier{
// get instance of Auth and Firestore
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;

// SEND MESSAGE
Future<void>sendMessage(String receiverId,String message)async {
    // get current user info
    final String currentUserId=_firebaseAuth.currentUser!.uid;
    final String currentUserEmail=_firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp=Timestamp.now();

    // create a new message
     Message newMessage=Message(
         senderId: currentUserId,
         senderEmail: currentUserEmail,
         receiverId: receiverId,
         message: message,
         timestamp: timestamp
     );
    // current chat room id from current user id and receiver id(sorted to ensure uniqueness)
  List<String> ids=[currentUserId,receiverId];
  ids.sort();
  String chatRoomId=ids.join('_');

   //add new message to database
  await _firebaseFirestore
      .collection('chat_room')
      .doc(chatRoomId)
      .collection('message')
      .add(newMessage.toMap());
}

// GET MESSAGE
Stream<QuerySnapshot> getMessage(String userId,String otherUserId){
  // construct chat room id from user's id(sorted to ensure it matches the id used when sending message)
  List<String> ids=[userId,otherUserId];
  ids.sort();
  String chatRoomId=ids.join('_');
  return _firebaseFirestore
      .collection('chat_room')
      .doc(chatRoomId)
      .collection('message')
      .orderBy('timestamp',descending: true)
      .snapshots();
  }

  //  DELETE MESSAGE
  Future<void>deleteMessage(String receiverId,Timestamp timestamp)async {
    // get current user info
    final String currentUserId=_firebaseAuth.currentUser!.uid;

    // current chat room id from current user id and receiver id(sorted to ensure uniqueness)
    List<String> ids=[currentUserId,receiverId];
    ids.sort();
    String chatRoomId=ids.join('_');

    // Construct a query to get the document based on timestamp
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .where('timestamp', isEqualTo: timestamp)
        .get();
  // Iterate through the documents and delete them
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
  }

  // EDIT NAME OF USER
   void editName(String uid,String email,String newName){
    _firebaseFirestore.collection('users').doc(uid).set({
       'uid':uid,
       'email':email,
       'name':newName,
    });
   }

   // DELETE USER ACCOUNT
    void deleteAccount(String uid){
     _firebaseFirestore.collection('users').doc(uid).delete();
     _firebaseAuth.currentUser!.delete();
    }





}