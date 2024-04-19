import 'package:chargease/Screens/profileScreen.dart';
import 'package:chargease/Screens/searchScreen.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  int _selectedIndex = 0; // For navigation bar selection

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
        title: Text('ChargeEase'), // Replace with your app's title
      ),
      body: SingleChildScrollView( // Enables scrolling
        child: Column(
          children: [
            // Welcome message (optional)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome back, [User Name]! Find your ideal charging station.', // Personalize with user name
                style: TextStyle(fontSize: 18.0),
              ),
            ),

            // Featured stations carousel (optional)
            Container(
              height: 200.0, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Replace with number of featured stations
                itemBuilder: (context, index) {
                  return Container(
                    width: 200.0, // Adjust width as needed
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        'assets/images/station.jpg', // Replace with image paths
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Recent bookings section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Bookings',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {}, // Handle "View All" button press
                    child: Text('View All'),
                  ),
                ],
              ),
            ),

            // List of recent bookings (replace with actual data fetching)
            ListView.builder(
              shrinkWrap: true, // Makes list content fit its size
              physics: NeverScrollableScrollPhysics(), // Disable list scrolling
              itemCount: 2, // Replace with number of recent bookings
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text('Station Name ${index + 1}'),
                  subtitle: Text('Booked for ${DateTime.now().add(Duration(days: index + 1))}'), // Placeholder date
                );
              },
            ),

            // Information cards or feed (replace with actual data fetching)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'News & Updates',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'New charging stations coming soon to your area! Stay tuned for more information.',
                      ),
                    ),
                  ),
                ],
              ),
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
