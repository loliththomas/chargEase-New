import 'package:chargease_owner/screens/addStationScreen.dart';
import 'package:chargease_owner/screens/OpeningScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();



  await Permission.location.request();
  final PermissionStatus status =await Permission.location.request();
  // Check if the user is already logged in
  bool isLoggedIn = await checkUserLoggedIn(); // Implement this function to check user login state
  print('login Sate : $isLoggedIn');
  if(status==PermissionStatus.denied){
    runApp(MyApp(isLoggedIn: isLoggedIn,showPermissionRequiredSnackBar: true,prefs:prefs));
  }else{
    runApp(MyApp(isLoggedIn: isLoggedIn,showPermissionRequiredSnackBar: false,prefs: prefs,));

  }
  
}

Future<bool> checkUserLoggedIn() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  return user != null;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool showPermissionRequiredSnackBar;
  final SharedPreferences prefs;
  const MyApp({Key? key, required this.isLoggedIn,required this.showPermissionRequiredSnackBar, required this. prefs}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 247, 250, 248),
          primaryColor: Color.fromARGB(255, 48, 136, 208)),
      home: isLoggedIn ? addStationScreen(prefs: prefs,) : OpeningScreen(prefs: prefs,),
      builder: (context, child) {
        return showPermissionRequiredSnackBar
            ? Scaffold(
                body: child,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location permission is required to use the app.'),
                      ),
                    );
                  },
                  child: Icon(Icons.warning),
                ),
              )
            : child!;

      },
    );
  }
}
