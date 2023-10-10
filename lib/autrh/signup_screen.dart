import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late FirebaseFirestore db;
  late FirebaseAuth auth;
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: 'Enter Name', border: OutlineInputBorder()),
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

                    try {
                      var credential =
                          await auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (credential.user!.uid.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Not Registered'),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content:
                                Text('The password provided is too weak.')));
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'The account already exists for that email.')));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Sign Up')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an Account",
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Login"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
