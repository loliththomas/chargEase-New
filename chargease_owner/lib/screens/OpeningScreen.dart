
//import 'package:chargeease_demo/screens/loginDemo.dart';
import 'package:chargease_owner/screens/loginScreen.dart';
import 'package:flutter/material.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  @override
  void initState() {
    gotoLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
        body: SafeArea(
          child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo path
              width: 75, // Adjust the width as needed
              height: 75, // Adjust the height as needed
            ),
            const SizedBox(
                width: 5), // Add some space between the logo and text
            const Text('chargeEase',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: 'Audiowide',
                  fontWeight: FontWeight.normal,
                ))
          ])),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      // ignore: prefer_const_constructors
      return LoginScreen();
    }));
  }
}
