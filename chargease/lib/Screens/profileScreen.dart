import 'package:chargease/Screens/homeScreen.dart';
import 'package:chargease/Screens/searchScreen.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatefulWidget {
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  int _selectedIndex = 2; // For navigation bar selection

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Potentially handle navigation logic here (e.g., navigate to other screens)
    });
    if (_selectedIndex == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen()));
    }
    else if (_selectedIndex == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
    }
    else if (_selectedIndex == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => profileScreen()));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'chargeEase',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Audiowide',
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
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
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logout logic here
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
