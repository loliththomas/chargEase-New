import 'package:chargease_owner/Functions/getUserData.dart';
import 'package:chargease_owner/Screens/addStationScreen.dart';
import 'package:chargease_owner/screens/loginScreen.dart';
import 'package:chargease_owner/screens/maps.dart';
import 'package:chargease_owner/screens/myStationsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profileScreen extends StatefulWidget {
  final SharedPreferences prefs;
  profileScreen({required this.prefs});
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  int _selectedIndex = 1; // For navigation bar selection
  late String? userName, email;


  
  @override
  void initState() {
    super.initState();
    // Fetch user's name when the widget initializes
    _getNameMail();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Potentially handle navigation logic here (e.g., navigate to other screens)
    });
    if (_selectedIndex == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => addStationScreen(prefs:widget.prefs)));
    } else if (_selectedIndex == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => profileScreen(prefs: widget.prefs,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 247, 250, 248),
          elevation: 3,
          shadowColor: Colors.grey,
          title: Text('chargeEase',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Audiowide',
                fontWeight: FontWeight.normal,
              ))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              userName as String,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              email as String,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            TextButton(
  onPressed: () {
   Navigator.push(context, MaterialPageRoute(builder: (context)=> MyStationsScreen(ownerName: userName)));
  },
  child: Text('View my stations '),
)
,
SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();
                widget.prefs.setString('docId', '');
                // Navigate to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(prefs:widget.prefs)), // Replace LoginScreen() with your actual login screen widget
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              spreadRadius: 3,
              offset: Offset(0, 3))
        ]),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.ev_station),
              label: 'Add Station',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:
              Color.fromARGB(255, 40, 154, 169), // Adjust color as needed
          onTap: _onItemTapped,
        ),
      ),
    );
  }
  
  void _getNameMail()async {
    String? ownerName =await getUserData(widget.prefs.getString('docId'), "Name"); 
    String? ownerMail =await getUserData(widget.prefs.getString('docId'), "Email"); 
    setState(() {
      email= ownerMail;
     userName= ownerName;
      
    });
    
  }
}
