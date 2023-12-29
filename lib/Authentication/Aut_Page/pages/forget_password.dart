
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../consts.dart';
import '../widgets/form_container_widget.dart';
import 'firebase_auth_services.dart';
import 'login_page.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login"),
      // ),
      body: Center(
        child: Container(
          height: double.infinity,width: 350,
          decoration: BoxDecoration(
            gradient: lightPinkBackground,
            // color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Forget Password",
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.secondary,
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                  labelText: "Enter your email",
                ),
                sizeVer(20),
                GestureDetector(
                  onTap: (){
                    try {
                      if(_emailController.text.toString().length>9) {
                      FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).then((value) =>
                      {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const LoginPage();
                              }
                              )
                          ),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email Sent please check your email"))
                        );
                        log("Email Sent");
                      }
                      else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Missing email"))
                        );
                      }
                    } on FirebaseAuthException catch (ex) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ex.message.toString()))
                      );
                      log("Missing email${ex.message}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child:Text("Forget Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  ),
                ),
                sizeVer(20),
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                  },
                  child: const Text("Login Page",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
