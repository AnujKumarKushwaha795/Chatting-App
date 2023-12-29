import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photos_app/Authentication/Aut_Page/pages/home_page.dart';
import 'package:photos_app/Authentication/Aut_Page/pages/login_page.dart';
import 'Authentication/Aut_Page/pages/forget_password.dart';
import 'Authentication/Aut_Page/pages/sign_up_page.dart';
import 'Authentication/Aut_Page/pages/splash_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      routes:{
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child:(FirebaseAuth.instance.currentUser !=null)?   HomePage():  LoginPage(),
          // child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/forgetPassword':(context)=>ForgetPassword(),
      },

    );

  }
}



/*
HOSTING WEBSITE
flutter login
flutter build web
firebase init hosting
Add script file to index.html file inside of build/web
firebase deploy
firebase hosting:channel:deploy "CHANNEL_ID"
*/

