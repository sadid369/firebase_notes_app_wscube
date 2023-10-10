import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes_app_wscube/autrh/signup_screen.dart';
import 'package:firebase_notes_app_wscube/home_screen.dart';
import 'package:firebase_notes_app_wscube/models/user_model.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  late FirebaseFirestore db;
  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();

    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  hintText: 'Enter Email', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  hintText: 'Enter Password', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {
                    var email = _emailController.text.toString();
                    var password = _passwordController.text.toString();
                    print(email + password);
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(credential.user!.uid)
                          .set(UserModel(
                            id: credential.user!.uid,
                            email: email,
                            password: password,
                          ).toMap());
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          id: credential.user!.uid,
                        ),
                      ));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: const Text('Login')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Account?",
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ));
                      },
                      child: Text("SignUp"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
