import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chargease/screens/loginScreen.dart';
import 'package:chargease/screens/dataentryScreen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final int otp;
  OtpScreen({required this.phoneNumber,required  this.otp});
  
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String  _otp='' ; // To store the entered OTP
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() {
   if(int.parse(_otp)== widget.otp){
    // otp matched
    print('otp matched');
     Navigator.push(context, 
     MaterialPageRoute(builder: (context)=> DataEntryScreen(phoneNumber: widget.phoneNumber)),
     );
   }
   else{
        print('otp missmatch');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("OTP does not match"),
        ));
   }
    print("Verifying OTP: $_otp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            /*mainAxisAlignment: MainAxisAlignment.center,*/
            children: [
              // Image
              Image.asset(
                'assets/images/otp.jpg',
              height: 250,
              width: 350,), // Replace with your otp icon path
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
                  )  
                ),
              ),
              SizedBox(height: 10.0),

              // Text - Enter the otp send to your number
              Text(
                'Enter the OTP sent to  +91 ${widget.phoneNumber}',
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
                        borderSide: BorderSide(
                          color: Color(0xD9D9D9)
                  
                        )
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _otp = value;
                      });
                    },
                    validator:(value) {
                      if (value == null || value.isEmpty){
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
                      Navigator.push(context, MaterialPageRoute(builder: ((context)  =>LoginScreen())));
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
              SizedBox(),
              Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: DecoratedBox(
                        child: SizedBox(
                          width: 110,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _formKey.currentState!.validate();
                              _verifyOtp();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              // Transparent background to ensure gradient shows
                            ),
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
                            ], // Your desired colors
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
