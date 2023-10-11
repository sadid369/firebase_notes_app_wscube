import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes_app_wscube/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends StatefulWidget {
  final String? title;
  const OtpScreen({Key? key, required this.title}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpFieldController otpController = OtpFieldController();
  var _phoneController = TextEditingController();
  late FirebaseFirestore db;
  late FirebaseAuth auth;
  var mVarificationId = '';
  var otpCode = "";
  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cleaning_services),
          onPressed: () {
            print("Floating button was pressed.");
            otpController.clear();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login With Mobile Number",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () {
                      auth.verifyPhoneNumber(
                        phoneNumber: "+88${_phoneController.text.toString()}",
                        verificationCompleted: (phoneAuthCredential) {
                          auth
                              .signInWithCredential(phoneAuthCredential)
                              .then((value) {
                            print("Logged in: ${value.user!.uid}");
                          });
                        },
                        verificationFailed: (error) {
                          print('Verification Failed: ${error.message}');
                        },
                        codeSent: (verificationId, forceResendingToken) {
                          mVarificationId = verificationId;
                          print('Code Sent $mVarificationId');
                        },
                        codeAutoRetrievalTimeout: (verificationId) {},
                      );
                    },
                    child: const Text('Sent')),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 15,
                    style: TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      print("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      otpCode = pin;
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: mVarificationId, smsCode: otpCode);
                    var cred = await auth.signInWithCredential(credential);
                    if (cred.user!.uid.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(id: cred.user!.uid),
                      ));
                    }
                  },
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        ));
  }
}
