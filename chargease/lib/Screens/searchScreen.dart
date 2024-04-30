import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:chargease/Screens/homeScreen.dart';
import 'package:chargease/Screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchScreen extends StatefulWidget {
      final SharedPreferences prefs; // Add SharedPreferences here

  const SearchScreen({required this.prefs});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
  late CameraPosition _initialPosition;
class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1; // For navigation bar selection
  late Position _currentPosition;

  @override
  void initState(){
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async{
    try{
      Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition=position;
        _initialPosition=CameraPosition(target: LatLng(_currentPosition.latitude,_currentPosition.longitude),zoom: 14);

      });
    }catch(e){
      print('error $e');
    }
  }

  final Completer<GoogleMapController> _controller=Completer();
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
              height: 400.0, // Adjust height as needed
              child: Stack(
                children: [
                  GoogleMap(initialCameraPosition: _initialPosition,
                  onMapCreated: (GoogleMapController controller ){
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  )

                  // Placeholder for your map widget (e.g., Google Maps)
                  // ... replace with your map implementation
                 ,
                 
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

           /* // List of stations (replace with actual data fetching)
            ListView.builder(
              shrinkWrap: true, // Makes list content fit its size
              physics: NeverScrollableScrollPhysics(), // Disable list scrolling
              itemCount: 2, // Replace with number of stations
              itemBuilder: (context, index) {
                return ListTile(  
                  leading: Icon(Icons.electric_car),
                  title: Text('Station Name ${index + 1}'),
                  subtitle: Text('9.30 Ramapuram'), // Replace with distance or other details
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
            ),*/
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
