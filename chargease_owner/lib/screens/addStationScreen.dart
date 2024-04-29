import 'dart:async';

import 'package:chargease_owner/screens/profileScreen.dart';
//import 'package:chargease_owner/widgets/LocationInput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chargease_owner/widgets/CustomTextField.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class addStationScreen extends StatefulWidget {
  @override
  State<addStationScreen> createState() => _addStationScreenState();
}

class _addStationScreenState extends State<addStationScreen> {
  int _selectedIndex = 0; // For navigation bar selection
  final stationController = TextEditingController();
  final slotsController = TextEditingController();
  final priceController = TextEditingController();
  late int? selectedSlots = 1;
  double? _latitude;
  double? _longitude;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Potentially handle navigation logic here (e.g., navigate to other screens)
    });
    if (_selectedIndex == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => addStationScreen()));
    } else if (_selectedIndex == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => profileScreen()));
    }
  }

  // void _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     latitude = position.latitude;
  //     longitude = position.longitude;
  //   });
  // }

  void _addStation() {
    String name = stationController.text;
    int slots = int.parse(slotsController.text);
    double price = double.parse(priceController.text);

    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String? uid =
            (documentSnapshot.data() as Map<String, dynamic>?)?['uid'];
        if (uid != null) {
          return FirebaseFirestore.instance
              .collection('owners')
              .where('uid', isEqualTo: uid)
              .get();
        } else {
          throw Exception('UID is null in user document');
        }
      } else {
        throw Exception('User document does not exist');
      }
    }).then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        String ownerName =
            (querySnapshot.docs.first.data() as Map<String, dynamic>?)?['name'];
        String _phoneNumber = (querySnapshot.docs.first.data()
            as Map<String, dynamic>?)?['phoneNumber'];

        return Stations.addStation(name, slots, price, _latitude!, _longitude!,
            ownerName, _phoneNumber);
      } else {
        throw Exception('Owner document not found');
      }
    }).catchError((error) {
      print('Error: $error');
    });

    //Stations.addStation(name, slots, price, latitude!, longitude!);
  }

  @override
  Widget build(BuildContext context) {
     //_formKey.currentState!.validate();
    return Scaffold(
  resizeToAvoidBottomInset: false,
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
      ),
    ),
  ),
  body: SafeArea(
    child: Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Add Station',
              style: GoogleFonts.getFont(
                "Poppins",
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18.0, // Reduced font size for title
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Your form fields
                    
Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 40, right: 40, bottom: 10),
                            child: CustomTextField(
                                labelText: "Station Name",
                                controller: stationController,
                                prefixIcon: Icons.ev_station),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, bottom: 5),
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'No of Slots',
                                  //prefix: Icon(Icons.grid_3x3),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 10.0,
                                  ),
                                ),
                                value: selectedSlots, // selected value
                                onChanged: (value) {
                                  setState(() {
                                    selectedSlots =
                                        value; // update selected value
                                  });
                                },
                                items: List.generate(
                                  10,
                                  (index) => DropdownMenuItem<int>(
                                    value: index + 1, // values from 1 to 10
                                    child: Text(
                                      '${index + 1}', // display numbers as dropdown items
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                // Add this line to ensure the hint is displayed initially
                                hint: Text('Select number of slots'),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 40, right: 40, bottom: 5),
                            child: CustomTextField(
                                labelText: "Price of slot",
                                controller: priceController),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30, bottom: 10),
              child: LocationInput(
                onLocationChanged: (latitude, longitude) {
                  setState(() {
                    _latitude = latitude;
                    _longitude = longitude;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                 print('inside validation');// _addStation();
                } else {
                  print("inside validity else");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 174, 227, 234),
            title: Text('Validation Error',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
              
            ),),
            content: Text('Please fill in all the fields!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK',style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ],
          );
        },
      );
    }
              },
              child: Text("Add Station"),
            ),
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
        offset: Offset(0, 3),
      )
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
      selectedItemColor: Color.fromARGB(255, 40, 154, 169),
      onTap: _onItemTapped,
    ),
  ),
);

  }
}



class Stations {
  static final CollectionReference _stations =
      FirebaseFirestore.instance.collection('Stations');

  static Future<void> addStation(
      String name,
      int slots,
      double price,
      double latitude,
      double longitude,
      String ownerName,
      String _phoneNumber) async {
    try {
      await _stations.add({
        'name': name,
        'owner': ownerName,
        'phone': _phoneNumber,
        'slots': slots,
        'price': price,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      print("Error adding document: $e");
    }
  }
}

class LocationInput extends StatefulWidget {
  final Function(double latitude, double longitude) onLocationChanged;

  const LocationInput({Key? key, required this.onLocationChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  LocationData? _locationData;
  var _isGettingLocation = false;
  bool isVisible = false;
  Completer<GoogleMapController> _controller = Completer();

  void _getCurrentLocation() async {
    Location location = Location();

    setState(() {
      _isGettingLocation = true;
      isVisible = true;
    });

    try {
      _locationData = await location.getLocation();
      setState(() {
        _isGettingLocation = false;
      });
      print("Location Fetched Successfully");
      // Pass current location data to parent widget
      widget.onLocationChanged(
        _locationData!.latitude!,
        _locationData!.longitude!,
      );
    } catch (error) {
      setState(() {
        _isGettingLocation = false;
      });
      print("Error getting current location: $error");
    }
  }

  Widget _buildMapPreview() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _locationData?.latitude ?? 0,
            _locationData?.longitude ?? 0,
          ),
          zoom: 13.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: MarkerId('user-location'),
            position: LatLng(
              _locationData?.latitude ?? 0,
              _locationData?.longitude ?? 0,
            ),
          ),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          label: Text("Get Current Location"),
          icon: Icon(Icons.location_on),
          onPressed: () {
            _getCurrentLocation();
          },
        ),
        Visibility(visible: isVisible, child: _buildMapPreview()),
      ],
    );
  }
}
