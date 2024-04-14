import 'package:flutter/material.dart';
import 'package:chargeease_demo/screens/OtpScreen.dart';
import 'dart:math';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Error message display state
  String _phoneNumberError = '';
  late int _otp;
  final _formKey =GlobalKey<FormState>(); // State management for form validation
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Associate form key for validation
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo_name.png', // Replace with your logo path
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType:
                    TextInputType.phone, // Optimized input for phone number
                controller: _phoneController,
                maxLength: 10, // Limit input length to 10 digits
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  counterText: "",
                  prefixIcon: Icon(Icons.phone),
                  errorText: _phoneNumberError.isNotEmpty
                      ? _phoneNumberError
                      : null, // Display error message if exists
                ),
                /* validator: (value) { // Validation logic
                  if (value!.isEmpty) {
                    return 'Phone number is required.';
                  } else if (value.length < 10) {
                    setState(() {
                      _phoneNumberError = 'Phone number must be at least 10 digits.';
                    });
                    return null; // Don't return error message to avoid showing 2 simultaneously
                  } else {
                    setState(() {
                      _phoneNumberError = ''; // Clear error message on valid input
                    });
                    return null;
                  }
                },*/
              ),
              SizedBox(height: 40.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: DecoratedBox(
                        child: SizedBox(
                          width: 150,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {

                              // Get the phone number
                              String phoneNumber = _phoneController.text;

                              //Generating otp
                              _otp=Random().nextInt(900000)+100000;
                              print("OTP is  $_otp");
                              // Perform validation
                              if (phoneNumber.isEmpty) {
                                setState(() {
                                  _phoneNumberError ='Phone number is required.';
                                });
                                return; // Prevent further action if empty
                              } else if (phoneNumber.length < 10) {
                                setState(() {
                                  _phoneNumberError =
                                      'Phone number must be at least 10 digits.';
                                });
                                return; // Prevent further action if invalid length
                              }

                              // Proceed with logic if valid
                              setState(() {
                                _phoneNumberError = ''; // Clear error if valid
                              });
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) =>OtpScreen(
                                phoneNumber: phoneNumber,
                                otp: 123456  /*_otp*/,)
                                )
                              );
                              // Implement your actual login functionality here, potentially using phoneNumber
                              // ...
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              // Transparent background to ensure gradient shows
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 63, 159, 172),
                              Color.fromARGB(255, 38, 123, 233)
                            ], // Your desired colors
                          ),
                        ),
                      ),
                    ),
                  ), // ... other UI elements
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
                        child: Text('OR',
                            style: TextStyle(
                                color: Color.fromARGB(255, 115, 111, 111))),
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
                      onPressed: () {
                        // Implement login button functionality, considering form validation
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, proceed with login process
                        }
                      },
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
                          Text(
                            'Continue with google',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
