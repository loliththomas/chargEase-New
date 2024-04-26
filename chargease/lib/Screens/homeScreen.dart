import 'package:chargease/Screens/profileScreen.dart';
import 'package:chargease/Screens/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chargease/widgets/StationButtonWidget.dart';

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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => homeScreen()));
    } else if (_selectedIndex == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SearchScreen()));
    } else if (_selectedIndex == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => profileScreen()));
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
          child: SingleChildScrollView(
            // Enables scrolling
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recently visited",
                      style: GoogleFonts.getFont('Poppins',
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 63, 159, 172)),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 100,
                  //color: Colors.amber,s
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        StationButtonWidget(
                          imageUrl: 'assets/images/station1.jpeg',
                          stationName: 'Station 1',
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        StationButtonWidget(
                            imageUrl: 'assets/images/station2.jpg',
                            stationName: 'station2',
                            onTap: () {}),
                        SizedBox(
                          width: 4,
                        ),
                        StationButtonWidget(
                            imageUrl: 'assets/images/station3.jpg',
                            stationName: 'station3',
                            onTap: () {}),
                        SizedBox(
                          width: 4,
                        ),
                        StationButtonWidget(
                            imageUrl: 'assets/images/station4.jpg',
                            stationName: 'station4',
                            onTap: () {}),
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby Stations",
                      style: GoogleFonts.getFont('Poppins',
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 63, 159, 172)),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 100,
                  //color: Colors.amber,s
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        StationButtonWidget(
                          imageUrl: 'assets/images/station1.jpeg',
                          stationName: 'Station 1',
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        
                        StationButtonWidget(
                            imageUrl: 'assets/images/station3.jpg',
                            stationName: 'station3',
                            onTap: () {}),
                        SizedBox(
                          width: 4,
                        ),
                        
                      ]),
                )
              ],
            ),
          ),
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
          selectedItemColor:
              Color.fromARGB(255, 40, 154, 169), // Adjust color as needed
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
