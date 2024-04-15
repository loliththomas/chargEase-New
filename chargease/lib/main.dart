import 'package:chargease/screens/OpeningScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
/*import 'package:chargease/screens/loginScreen.dart';*/
import 'package:flutter/material.dart';

void main() async{
  // Initialize Firebase before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 247, 250, 248),
        primaryColor: Color.fromARGB(255, 48, 136, 208)
      ),
    home: OpeningScreen(),
      
    );
  }

}




