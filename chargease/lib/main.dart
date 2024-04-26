import 'package:chargease/screens/OpeningScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
/*import 'package:chargease/screens/loginScreen.dart';*/
import 'package:flutter/material.dart';

void main() async{
  // Initialize Firebase before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Permission.location.request();

  // Request location permission
final PermissionStatus status = await Permission.location.request();

if (status == PermissionStatus.denied) {
    // Show a SnackBar to inform the user about the importance of location access
    runApp(MyApp(showPermissionRequiredSnackBar: true));
  } else {
    runApp(const MyApp(showPermissionRequiredSnackBar: false));
  }
  

} 

class MyApp extends StatelessWidget {
  final bool showPermissionRequiredSnackBar;

  const MyApp({Key? key, required this.showPermissionRequiredSnackBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 247, 250, 248),
        primaryColor: Color.fromARGB(255, 48, 136, 208)
      ),
    home: OpeningScreen(),
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




