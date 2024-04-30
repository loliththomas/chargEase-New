import 'dart:ui';

import 'package:chargease_owner/Functions/checkUserData.dart';
import 'package:chargease_owner/screens/addStationScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chargease_owner/screens/loginScreen.dart';
import 'package:chargease_owner/screens/dataentryScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final SharedPreferences prefs; // Add SharedPreferences here

  OtpScreen(
      {required this.phoneNumber,
      required this.verificationId,
      required this.prefs});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  Map<String, dynamic>? ownerData;
  String userExist = 'n';
  String? uid;

  TextEditingController otpController = TextEditingController();
  void updateUserExist(bool value){
    setState(() {
      userExist='y';
    });
  }
  //Funtion to check if the user is already existing

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
                  'Owner Verification',
                  style: GoogleFonts.getFont(
                    "Poppins",
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),

                // Text - Enter the otp send to your number
                Text(
                  'Enter the OTP sent to ${widget.phoneNumber}',
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
                                builder: ((context) => LoginScreen(
                                      prefs: widget.prefs,
                                    ))));
                        // Handle Change Number click
                      },
                      child: Text('Change Number'),
                    ),
                    SizedBox(),
                    TextButton(
                      onPressed: () {},
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

                                String? userId =
                                    await checkUserData(widget.phoneNumber,updateUserExist);
                                widget.prefs.setString('docId', userId ?? '');
                                print('user id $userId');
                                print('user exist $userExist');
                                if (userId==null) {
                                  print('no user found in db');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DataEntryScreen(
                                        phoneNumber: widget.phoneNumber,
                                        prefs: widget.prefs,
                                      ),
                                    ),
                                  );
                                } else if (userId==widget.prefs.getString('docId')) {
                                    print('object exists');
                                    setState(() {
                                      uid = userId;
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => addStationScreen(
                                            prefs: widget.prefs),
                                      ),
                                    );
                                  };
                              } catch (e) {
                                log(e.toString());
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 174, 227, 234),
                                      title: Text(
                                        'Validation Error',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text('Enter Correct OTP'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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
