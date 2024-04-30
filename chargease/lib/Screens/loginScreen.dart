import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chargease/screens/OtpScreen.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs; // Add SharedPreferences here
  LoginScreen({required this.prefs});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _phoneNumberError = '';
  late String verificationId; // Declare verificationId here
  late int _otp;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? phoneNumber; // Declare phoneNumber variable


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
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  counterText: "",
                  border: OutlineInputBorder(),
                  errorText: _phoneNumberError.isNotEmpty
                      ? _phoneNumberError
                      : null,
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  setState(() {
                    // Update phone number whenever it changes
                    phoneNumber = phone.completeNumber;
                    print(phoneNumber) ;// Add phone number to variable
                  });
                },
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
                          String? enteredPhoneNumber = phoneNumber; // Get entered phone number
                          if (enteredPhoneNumber == null || enteredPhoneNumber.isEmpty) {
                            setState(() {
                              _phoneNumberError = 'Phone number is required.';
                            });
                            return;
                          } else if (!_isValidPhoneNumber(enteredPhoneNumber)) {
                            setState(() {
                              _phoneNumberError = 'Invalid phone number format.';
                            });
                            return;
                          }

                          setState(() {
                            _phoneNumberError = '';
                          });

                          _otp = Random().nextInt(900000) + 100000;
                          print("OTP is $_otp");

                          // Send OTP to the user's phone number
                          _auth.verifyPhoneNumber(
                            phoneNumber: enteredPhoneNumber,
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String vId, int? resendToken) {
                              verificationId = vId; // Assign verificationId here
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    verificationId: verificationId,
                                    phoneNumber: enteredPhoneNumber,
                                    prefs: widget.prefs
                                    
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
