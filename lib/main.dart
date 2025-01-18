import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Categories/add.dart';
import 'package:note_app/HomePage.dart';
import 'package:note_app/auth/signin.dart';
import 'package:note_app/auth/signup.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "",
              appId: "",
              messagingSenderId: "",
              projectId: ""),
        )
      : await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[900],
              titleTextStyle: TextStyle(
                  color: Colors.blue[200], fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.blue[200]))),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : Signin(),
      routes: {
        "home": (context) => HomePage(),
        "Signin": (context) => Signin(),
        "Signup": (context) => SignUp(),
        "AddCategory": (context) => AddCategory(),
      },
    );
  }
}
