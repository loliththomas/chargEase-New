import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chargease/screens/loginScreen.dart';
import 'package:chargease/screens/dataentryScreen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final int otp;
  final String verificationId;
  OtpScreen({required this.phoneNumber, required this.otp,required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = ''; // To store the entered OTP
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() {
    if (_otp == widget.otp.toString()) {
      // OTP matched
      print('OTP matched');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataEntryScreen(phoneNumber: widget.phoneNumber)),
      );
    } else {
      // OTP mismatched
      print('OTP mismatch');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("OTP does not match"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xD9D9D9)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _otp = value;
                      });
                    },
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
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginScreen())));
                      // Handle Change Number click
                    },
                    child: Text('Change Number'),
                  ),
                  SizedBox(),
                  TextButton(
                    onPressed: () {
                      // Handle resend otp
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _verifyOtp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        ),// Transparent background to ensure gradient shows
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
