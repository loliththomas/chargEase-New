import 'package:chargease/Functions/mapLauncher.dart';
import 'package:chargease/Screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bookingConfirmationScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final Map<String, dynamic> stationData;
  final String bookingId;
  bookingConfirmationScreen(
      {required this.prefs,
      required this.stationData,
      required this.bookingId});

  @override
  State<bookingConfirmationScreen> createState() =>
      _bookingConfirmationScreenState();
}

class _bookingConfirmationScreenState extends State<bookingConfirmationScreen> {
  late Map<String, dynamic> bookingData = {};

  @override
  void initState() {
    super.initState();
    _fetchBooking(widget.bookingId,);
    print('datas in booking $bookingData');
  }

  void _fetchBooking(String bookingId, ) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Bookings')
          .doc(bookingId)
          .get();

      // Check if the document exists
      if (snapshot.exists) {
        // Get all the data as a Map<String, dynamic>
        setState(() {
          bookingData = snapshot.data() as Map<String, dynamic>;
        }); 
      } else {
        // Document with the provided ID does not exist
        print('Document does not exist');
      }
    } catch (e) {
      print("Error fetching booking: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAF8),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
        elevation: 3,
        shadowColor: Colors.grey,
        title: Text(
          'Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 350,
          decoration: BoxDecoration(
            color: Color(0xFF57B1BC),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 54, 52, 52),
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(4, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Booking Confirmed',
                  style: GoogleFonts.getFont(
                    "Anek Malayalam",
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Id : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.bookingId}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Station Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.stationData["Name"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Location: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.stationData["Location"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Price: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.stationData["Price"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Status: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Successful",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        double destLat=widget.stationData["Latitude"];
                        double destLng=widget.stationData["Longitude"];
                        launchGoogleMaps(destLat, destLng);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF67CEDB),
                        elevation: 3,
                        shadowColor: Colors.black,
                        splashFactory: InkRipple.splashFactory,
                      ),
                      child: Text(
                        'Get Dierection',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => homeScreen(
                              prefs: widget.prefs,
                            ),
                          ),
                        );
                        // Implement payment functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF67CEDB),
                        elevation: 3,
                        shadowColor: Colors.black,
                        splashFactory: InkRipple.splashFactory,
                      ),
                      child: Text(
                        'Go to home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
