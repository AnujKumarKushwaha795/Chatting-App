import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:photos_app/Ui_Helper/ui_helper.dart';
import 'package:photos_app/consts.dart';
class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  Future<User?> signUpWithEmailAndPassword(String email, String password,String name,BuildContext context) async {
    try {
      // log("i am going to signup");
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // log("user===${credential.user}");
      firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).set(
      {
        'uid':_auth.currentUser!.uid,
        'email':email,
        'name':name,
      });
      // log("User added to firebase from signUp");
      toast("User added to firebase");
      return credential.user;
    } catch (e) {
      UiHelper.showAlertDialog(context, "Some Error Occured", e.toString());
      // log("error in signUp=$e");
      // log("Some error occurred in sign Up");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password,BuildContext context) async {
    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      // firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).set(
      // {
      //   'uid':_auth.currentUser!.uid,
      //   'email':email
      // },SetOptions(merge: true));   // if name and email already exist then merge it.
      // log("User added to firebase from signPage");
      return credential.user;
    }
    catch (e) {
      UiHelper.showAlertDialog(context, "Some Error Occured", e.toString());
      // Navigator.pop(context);
      // log('error in login=$e');
      // log("Some error occurred in log in");
    }
    return null;
  }

}