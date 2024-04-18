import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chargease/screens/OtpScreen.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _phoneNumberError = '';
  late String verificationId; // Declare verificationId here
  late int _otp;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo_name.png'),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                maxLength: 13, // Adjust the length according to E.164 format
                decoration: InputDecoration(
                  labelText: 'Phone Number (+CountryCodeXXXXXXXXX)',
                  counterText: "",
                  prefixIcon: Icon(Icons.phone),
                  errorText: _phoneNumberError.isNotEmpty
                      ? _phoneNumberError
                      : null,
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: DecoratedBox(
                    child: SizedBox(
                      width: 150,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          String phoneNumber = _phoneController.text;
                          _otp = Random().nextInt(900000) + 100000;
                          print("OTP is $_otp");

                          if (phoneNumber.isEmpty) {
                            setState(() {
                              _phoneNumberError = 'Phone number is required.';
                            });
                            return;
                          } else if (!_isValidPhoneNumber(phoneNumber)) {
                            setState(() {
                              _phoneNumberError = 'Invalid phone number format.';
                            });
                            return;
                          }

                          setState(() {
                            _phoneNumberError = '';
                          });

                          // Send OTP to the user's phone number
                          _auth.verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String vId, int? resendToken) {
                              verificationId = vId; // Assign verificationId here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    verificationId: verificationId,
                                    phoneNumber: phoneNumber,
                                    otp: 123456/*_otp*/,
                                  ),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        ),
                        child: Text('Sign up', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 63, 159, 172),
                          Color.fromARGB(255, 38, 123, 233)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      indent: 120,
                      thickness: 1,
                      color: Color.fromARGB(255, 115, 111, 111),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Color.fromARGB(255, 115, 111, 111)),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      endIndent: 120,
                      thickness: 1,
                      color: Color.fromARGB(255, 115, 111, 111),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 250,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    side: BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/google.png", height: 30),
                      SizedBox(width: 10),
                      Text('Continue with Google', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidPhoneNumber(String value) {
    // Implement validation logic here for E.164 format
    // Example validation: Check if value starts with '+' and contains only digits after that
    if (value.startsWith('+') && value.substring(1).contains(RegExp(r'^[0-9]*$'))) {
      return true;
    }
    return false;
  }
}



//currently firebase il oru testingin vendi my num kodthitund + verification code set to 123456