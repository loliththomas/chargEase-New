import 'package:chargease/Functions/getUserData.dart';
import 'package:chargease/Screens/homeScreen.dart';
import 'package:chargease/Screens/loginScreen.dart';
import 'package:chargease/Screens/searchScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatefulWidget {
      final SharedPreferences prefs; // Add SharedPreferences here

  const profileScreen({required this.prefs});
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  int _selectedIndex = 2; // For navigation bar selection
  late String? name, email;

  @override
  void initState() {
    super.initState();
    // Fetch user's name when the widget initializes
    _getNameMail();
  }


  void _getNameMail() async {
    String? userName =
        await getUserData(widget.prefs.getString('docId'), "Name");
    String? userMail =
        await getUserData(widget.prefs.getString('docId'), "Email");
    setState(() {
      email = userMail;
      name = userName;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Potentially handle navigation logic here (e.g., navigate to other screens)
    });
    if (_selectedIndex == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => homeScreen(prefs: widget.prefs,)));
    } else if (_selectedIndex == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SearchScreen(prefs: widget.prefs)));
    } else if (_selectedIndex == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => profileScreen(prefs: widget.prefs)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
        elevation: 3,
        shadowColor: Colors.grey,
        title: Text('chargeEase',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Audiowide',
                  fontWeight: FontWeight.normal,
                )
              )
       ),
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
              name as String,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              email as String,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
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
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              spreadRadius: 3,
              offset: Offset(0,3)
            )
          ]
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 40, 154, 169), // Adjust color as needed
          onTap: _onItemTapped,
        )
        ),
    );
  }
}
