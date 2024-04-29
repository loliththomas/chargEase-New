import 'package:chargease/Screens/dataentryScreen.dart';
import 'package:chargease/Screens/homeScreen.dart';
import 'package:chargease/Screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:developer';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  OtpScreen(
      {required this.phoneNumber,
      required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  Map<String,dynamic>? userData;
  String userExist='n';
  TextEditingController otpController = TextEditingController();
//Funtion to check if the user is already existing

  Future<void> checkUserData(String phoneNumber) async {
    try {
      // Reference to the Firestore collection
      CollectionReference users = FirebaseFirestore.instance.collection('Users');

      // Query to check if a document with the given phone number exists
      QuerySnapshot querySnapshot =
          await users.where('phoneNumber', isEqualTo: phoneNumber).get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Extract data from the first document found (assuming phone numbers are unique)
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('user found $userData');
        setState(() {
          userExist='y';
          print("user exist variable : $userExist");
        });

        //return userData;
      } else {
        print("${widget.phoneNumber} user not found");

        // If no documents were found, return null
        //return null;
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching user data: $e");
      //return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Image
                Image.asset(
                  'assets/images/otp.jpg',
                  height: 250,
                  width: 350,
                ), // Replace with your otp icon path
                SizedBox(height: 10.0),

                // Text - VERIFICATION
                Text(
                  'Verification',
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),

                // Text - Enter the otp send to your number
                Text(
                  'Enter the OTP sent to +91 ${widget.phoneNumber}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 20.0),

                // Text Field for OTP
                Form(
                  key: _formKey,
                  child: Container(
                    child: TextFormField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xD9D9D9)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "OTP required";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.0),

                // Row with Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LoginScreen())));
                        // Handle Change Number click
                      },
                      child: Text('Change Number'),
                    ),
                    SizedBox(),
                    TextButton(
                      onPressed: () {
                      },
                      child: Text('Resend OTP'),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                // Verify Button
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: DecoratedBox(
                      child: SizedBox(
                        width: 110,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                PhoneAuthCredential credential =
                                    await PhoneAuthProvider.credential(
                                        verificationId: widget.verificationId,
                                        smsCode: otpController.text.toString());
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);

                                await checkUserData(
                                    widget.phoneNumber); // Check if user exists

                                if (userExist == 'n') {  // if user not exist go to dataentry
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DataEntryScreen(
                                        phoneNumber: widget.phoneNumber,
                                      ),
                                    ),
                                  );
                                } else if (userExist == 'y') {  //if user exist directly go to homescreen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => homeScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                log(e.toString());
                                _scaffoldKey.currentState!.showSnackBar(
                                  SnackBar(
                                    content: Text("OTP does not match"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(0, 255, 255, 255),
                          ), // Transparent background to ensure gradient shows
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}