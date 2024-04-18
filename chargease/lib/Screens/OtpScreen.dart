import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chargease/screens/loginScreen.dart';
import 'package:chargease/screens/dataentryScreen.dart';
import 'dart:developer';
//import "package:twilio_flutter/twilio_flutter.dart";

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
  TextEditingController otpController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginScreen())));
                      // Handle Change Number click
                    },
                    child: Text('Change Number'),
                  ),
                  SizedBox(),
                  TextButton(
                    onPressed: () {                    },
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
                              FirebaseAuth.instance
                                  .signInWithCredential(credential)
                                  .then((value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DataEntryScreen(
                                          phoneNumber: widget.phoneNumber)),
                                );
                              });
                            } catch (e) {
                              log(e.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("OTP does not match"),
                              ));
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
    );
  }
}
