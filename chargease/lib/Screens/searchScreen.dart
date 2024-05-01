import 'dart:async';
import 'package:chargease/Screens/bookingScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:chargease/Screens/homeScreen.dart';
import 'package:chargease/Screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:cloud_firestore/cloud_firestore.dart";

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
  late List<Marker> _markers = [];
  late List<DocumentSnapshot> _stationList =
      []; // List to store station documents
      late List<String> stationIdS = []; // List to store document IDs

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchStations(_markers, _stationList,stationIdS);
    print('Markers : $_markers');
    print("no of stations  : ${_stationList.length}");
  }

  // void _onMarkerTapped(MarkerId markerId) {
  //   Marker? markerNotFound=Marker(markerId: MarkerId("null"));
  //   // Find the marker with the tapped markerId from the _markers list
  //   Marker? tappedMarker = _markers.firstWhere(
  //     (marker) => marker.markerId == markerId,
  //     orElse: ()=> markerNotFound

  //   );

  //   if (tappedMarker != markerNotFound) {
  //     // Extract station details from the tapped marker
  //     String stationName = tappedMarker.infoWindow.title ?? '';
  //     // Find the corresponding station document from _stationList
  //     DocumentSnapshot? stationDocument = _stationList.firstWhere(
  //       (document) => document['Name'] == stationName,
  //     );

  //     if (stationDocument != null) {
  //       // Show bottom modal sheet with station details
  //       showModalBottomSheet(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return Container(
  //             padding: EdgeInsets.all(16.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   'Station Details',
  //                   style: TextStyle(
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10.0),
  //                 Text('Station Name: ${stationDocument['Name']}'),
  //                 Text('Address: ${stationDocument['Location']}'),
  //                 // Add more details as needed
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  void _fetchStations(
      List<Marker> markers, List<DocumentSnapshot> _stationList,List<String> stationIdS) async {
    _stationList.clear();
    stationIdS.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Stations').get();

    querySnapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      double latitude = data['Latitude']; // Latitude field from Firestore
      double longitude = data['Longitude']; // Longitude field from Firestore
      String name = data['Name']; // Name field from Firestore
      print("latitude : $latitude  Longitude :$longitude  station name: $name");
      // Create a marker for each station
      String sId=document.id;
      LatLng _position = LatLng(latitude, longitude);
      print("position $_position");
      print('marker id${MarkerId(name)}');
      // Create a marker for each station
      Marker marker = Marker(
        markerId: MarkerId(name),
        position: _position,
        infoWindow: InfoWindow(
          title: name,
        ),
      );
      print("after marker create");

      markers.add(marker);
      stationIdS.add(sId);
      print("after marker to list");
      _stationList.add(document);
    });

    // setState(() {
    //   _markers = markers;
    // });
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _initialPosition = CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 14);
      });
    } catch (e) {
      print('error $e');
    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Potentially handle navigation logic here (e.g., navigate to other screens)
    });
    if (_selectedIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => homeScreen(
                    prefs: widget.prefs,
                  )));
    } else if (_selectedIndex == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchScreen(prefs: widget.prefs)));
    } else if (_selectedIndex == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => profileScreen(prefs: widget.prefs)));
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
      body: Column(
        children: [
          // Search bar for stations (optional)
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search stations',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //   ),
          // ),

          // Map container to display stations
          Container(
            height: 615.0, // Adjust height as needed
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(_markers),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EV Stations',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16.0),
                              child: ListView.separated(
                                itemCount: _stationList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                      height:
                                          16); // Adjust the height as needed
                                },
                                itemBuilder: (context, index) {
                                  // Extract station details from each document
                                  Map<String, dynamic> stationData =
                                      _stationList[index].data()
                                          as Map<String, dynamic>;
                                  String stationName = stationData['Name'];
                                  String stationAddress =
                                      stationData['Location'];
                                  int availableSlots = stationData[
                                      'Available Slots']; // Example field name, replace with actual field name
                                  double pricePerSlot = stationData[
                                      'Price']; // Example field name, replace with actual field name

                                  // Build and return a ListTile for each station
                                  return Stack(children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 110,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              stationName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Location : $stationAddress"),
                                                      Text(
                                                          'Available Slots: $availableSlots'),
                                                      Text(
                                                        '\Price: ${pricePerSlot.toStringAsFixed(2)}/-',
                                                        // Format price with two decimal places
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  // Spacer pushes the icon to the right
                                                  //Spacer(),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              // Get the index of the pressed station
      int index = _stationList.indexWhere((doc) => doc['Name'] == stationName);
      if (index != -1) {
        // Pass the document ID to bookingScreen
        String documentId = stationIdS[index];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => bookingScreen(
              prefs: widget.prefs,
              stationData: stationData,
              stationId: documentId, // Pass document ID
            ),
          ),
        );
      }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 40,
                                      right: 30,
                                      child: Icon(Icons.navigate_next),
                                    )
                                  ]);
                                },
                              ),
                            );
                          },
                        );
                      }, // Handle "View All" button press
                      child: Text('View All'),
                    ),
                  ],
                ),

                // Container(height: 80,
                //   color:  Colors.black,),
                //   Container(height: 50,
                //   color:  Colors.blue,),
                //   Container(height: 50,
                //   color:  Colors.red,),
              ],
            ),
          ),
        ],
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
          )),
    );
  }
}
