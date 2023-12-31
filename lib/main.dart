import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notes_app_wscube/autrh/login_screen.dart';
import 'package:firebase_notes_app_wscube/autrh/otp_screen.dart';
import 'package:firebase_notes_app_wscube/autrh/signup_screen.dart';
import 'package:firebase_notes_app_wscube/firebase_options.dart';
import 'package:firebase_notes_app_wscube/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OtpScreen(title: 'otp'),
    );
  }
}
