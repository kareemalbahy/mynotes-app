import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'auth/signup.dart';
import 'categories/addcategory.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: (FirebaseAuth.instance.currentUser != null ) //&&
            //FirebaseAuth.instance.currentUser!.emailVerified)
        ? Homepage()
        : login(),
        routes: {
          "login": (context) => login(),
          "signup": (context) => signup(),
          "homepage": (context) => Homepage(),
          "addcategory": (context) => AddCategory(),
        });
  }
}
