import 'package:chargease/Screens/homeScreen.dart';
import 'package:chargease/Screens/profileScreen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1; // For navigation bar selection

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
      body: SingleChildScrollView(
        // Enables scrolling
        child: Column(
          children: [
            // Search bar for stations (optional)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search stations',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            // Map container to display stations
            Container(
              height: 300.0, // Adjust height as needed
              child: Stack(
                children: [
                  // Placeholder for your map widget (e.g., Google Maps)
                  // ... replace with your map implementation
                  Center(
                    child: Text('Map Here'), // Placeholder for now
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: FloatingActionButton(
                      onPressed: () {}, // Handle "Locate Me" button press
                      child: Icon(Icons.location_on),
                    ),
                  ),
                ],
              ),
            ),

            // List of stations section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EV Stations',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {}, // Handle "View All" button press
                    child: Text('View All'),
                  ),
                ],
              ),
            ),

            // List of stations (replace with actual data fetching)
            ListView.builder(
              shrinkWrap: true, // Makes list content fit its size
              physics: NeverScrollableScrollPhysics(), // Disable list scrolling
              itemCount: 4, // Replace with number of stations
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.electric_car),
                  title: Text('Station Name ${index + 1}'),
                  subtitle: Text('9.30 Ramapuram'), // Replace with distance or other details
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
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
